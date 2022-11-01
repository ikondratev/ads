module HTTP
  module Actions
    module Commands
      class ShowAllAds < BaseCommand
        include Dry::Monads[:result]

        include Import[
                  command: "services.posting.commands.show_all_posts",
                ]

        def handle(_req, res)
          result = command.call

          case result
          when Success
            res.status = 200
            res.body = result.value!.to_json
          when Failure
            failure_response(result)
          end
        end
      end
    end
  end
end
