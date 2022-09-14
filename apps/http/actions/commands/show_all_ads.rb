require "json"
require "hanami/action"

module HTTP
  module Actions
    module Commands
      class ShowAllAds < Hanami::Action
        include Dry::Monads[:result]

        include Import[
                  configuration: "hanami.action.configuration",
                  command: "services.posting.commands.show_all_posts"
                ]

        def handle(req, res)
          result = command.call

          case result
          in Success
            res.status  = 200
            res.body    = result.value!.to_json
          in Failure[:account_not_found, error_message]
            halt 404, error_message.to_json
          in Failure[:queue_full, error_message]
            halt 422, error_message.to_json
          in Failure[:toys_exist_in_queue, error_message]
            halt 422, error_message.to_json
          end
        end
      end
    end
  end
end