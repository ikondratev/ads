require_relative "api"

module AuthService
  module Rpc
    class Client
      include Dry::Monads[:result]
      include API

      extend Dry::Initializer[undefined: false]

      option :queue, default: proc { create_queue }
      option :reply_queue, default: proc { create_reply_queue }
      option :lock, default: proc { Mutex.new }
      option :condition, default: proc { ConditionVariable.new }

      AUTH_QUEUE_CHANNEL = "auth".freeze
      REPLY_TO_QUEUE_CHANNEL = "auth_reply".freeze

      def start
        @reply_queue.subscribe do |_info, properties, payload|
          if properties.correlation_id == @correlation_id
            @user_id = JSON(payload)["user_id"]
            @lock.synchronize { @condition.signal }
          end
        end

        self
      end

      private

      attr_writer :correlation_id

      def create_queue
        Queues::RabbitMq.channel.queue(AUTH_QUEUE_CHANNEL, durable: true)
      end

      def create_reply_queue
        Queues::RabbitMq.channel.queue(REPLY_TO_QUEUE_CHANNEL)
      end

      def publish(payload, **opts)
        @lock.synchronize do
          self.correlation_id = SecureRandom.uuid

          @queue.publish(
            payload,
            opts.merge(
              app_id: "ads",
              reply_to: @reply_queue.name,
              correlation_id: @correlation_id,
              headers: {
                request_id: Thread.current[:request_id]
              }
            )
          )

          @condition.wait(@lock)
        end
      end
    end
  end
end
