require "json"
require "hanami/action"

module HTTP
  module Actions
    module Commands
      class BaseCommand < Hanami::Action
        include Dry::Monads[:result, :try]

        include Import[
                  configuration: "hanami.action.configuration",
                  error_handler: "http.actions.handlers.errors",
                  authenticate_user: "auth_service.http.client"
                ]

        protected

        def success(res, status = 200, body = "")
          res.status = status
          res.body = body.to_json
        rescue StandardError
          failure_response(Failure([:fatal_error]))
        end

        def failure_response(result)
          error_result = error_handler.call(result)
          halt error_result[:code], error_result[:error].to_json
        end
      end
    end
  end
end
