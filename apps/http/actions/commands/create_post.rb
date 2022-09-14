require "json"
require "hanami/action"

module HTTP
  module Actions
    module Commands
      class CreatePost < Hanami::Action
        include Dry::Monads[:result]

        include Import[
                  configuration: "hanami.action.configuration",
                  command: "services.posting.commands.create_post"
                ]

        def handle(req, res)
          result = command.call(req.params[:title], req.params[:city], req.params[:user_id])

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
