module HTTP
  module Actions
    module Commands
      class CreatePost < BaseCommand
        include Dry::Monads[:result]
        include Import[
                  command: "services.posting.commands.create_post"
                ]

        def handle(req, res)
          user_id_request = authenticate_user.call(req.env["HTTP_BEARER"])

          failure_response(user_id_request) unless user_id_request.success

          result = command.call(req.params.to_h.merge(user_id: user_id_request.success[:user_id]))

          case result
          when Success
            res.status = 201
          when Failure
            failure_response(result)
          end
        end
      end
    end
  end
end
