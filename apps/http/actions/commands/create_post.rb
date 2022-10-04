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
                  error_handler: "http.actions.handlers.errors",
                  authenticate_user: "auth_service.api.auth_user"
                ]

        def handle(req, res)
          user_id_request = authenticate_user.call(req.env["HTTP_BARIER"])

          failure_response(user_id_request) unless user_id_request.success

          params = req.params
          params.merge!(user_id_request[:user_id])

          result = command.call(params)

          case result
          when Success
            res.status = 201
          when Failure
            failure_response(result)
          end
        end

        private

        def failure_response(result)
          error_result = error_handler.call(result)
          halt error_result[:code], error_result[:error].to_json
        end
      end
    end
  end
end
