require_relative "api"

module GeocoderService
  module Rpc
    class Client
      extend Dry::Initializer[undefined: false]
      include Api

      option :queue, default: proc { create_queue }

      private

      def create_queue
        Queues::RabbitMq.channel.queue(
          Settings.rabbit_mq.channels.geocoding,
          durable: true
        )
      end

      def publish(payload, **opts)
        @queue.publish(
          payload,
          opts.merge(
            app_id: Settings.app.name,
            headers: {
              request_id: Thread.current[:request_id]
            }
          )
        )
      end
    end
  end
end
