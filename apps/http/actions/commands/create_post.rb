require "json"
require "hanami/action"

module HTTP
  module Actions
    module Commands
      class CreatePost < Hanami::Action
        include Dry::Monads[:result]

        include Import[
                  configuration: "hanami.action.configuration",
                  command: "services.posting.commands.create_post",
                  error_handler: "http.actions.handlers.errors"
                ]

        def handle(req, res)
          result = command.call(req.params)

          case result
          when Success
            res.status = 201
          when Failure
            error_result = error_handler.call(result)
            halt error_result[:code], error_result[:error].to_json
          end
        end
      end
    end
  end
end
