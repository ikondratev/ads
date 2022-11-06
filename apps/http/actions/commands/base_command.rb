require "json"
require "hanami/action"

module HTTP
  module Actions
    module Commands
      class BaseCommand < Hanami::Action
        include Dry::Monads[:result]

        include Import[
                  configuration: "hanami.action.configuration",
                  error_handler: "http.actions.handlers.errors",
                  authenticate_user: "auth_service.http.client"
                ]

        private

        def failure_response(result)
          error_result = error_handler.call(result)
          halt error_result[:code], error_result[:error].to_json
        end
      end
    end
  end
end
