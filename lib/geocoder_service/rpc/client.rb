require_relative "api"

module GeocoderService
  module Rpc
    class Client
      extend Dry::Initializer[undefined: false]
      include Api

      option :queue, default: proc { create_queue }

      GEOCODE_QUEUE_CHANNEL = "geocoding".freeze

      private

      def create_queue
        Queues::RabbitMq.channel.queue(GEOCODE_QUEUE_CHANNEL, durable: true)
      end

      def publish(payload, **opts)
        @queue.publish(
          payload,
          opts.merge(
            app_id: "ads",
            headers: {
              request_id: Thread.current[:request_id]
            }
          )
        )
      end
    end
  end
end
