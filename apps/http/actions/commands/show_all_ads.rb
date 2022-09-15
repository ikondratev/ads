require "json"
require "hanami/action"

module HTTP
  module Actions
    module Commands
      class ShowAllAds < Hanami::Action
        include Dry::Monads[:result]

        include Import[
                  configuration: "hanami.action.configuration",
                  command: "services.posting.commands.show_all_posts",
                  error_handler: "http.actions.handlers.errors"
                ]

        def handle(_req, res)
          result = command.call

          case result
          when Success
            res.status = 200
            res.body = result.value!.to_json
          when Failure
            error_result = error_handler.call(result)
            halt error_result[:code], error_result[:error].to_json
          end
        end
      end
    end
  end
end
