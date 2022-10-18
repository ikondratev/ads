module HTTP
  module Actions
    module Commands
      class CreatePost < BaseCommand
        include Dry::Monads[:result]
        include Import[
                  command: "services.posting.commands.create_post"
                ]

        def handle(req, res)
          auth_request = authenticate_user.auth(req.env["HTTP_AUTHORIZATION"])

          failure_response(auth_request) unless auth_request.success

          result = command.call(req.params.to_h.merge(user_id: auth_request.success[:user_id]))

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
