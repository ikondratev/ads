module HTTP
  module Actions
    module Commands
      class UpdateCoordinates < BaseCommand
        include Dry::Monads[:result]
        include Import[
                  command: "services.posting.commands.update_coordinates"
                ]

        def handle(req, res)
          result = command.call({ post_id: req.params[:id]&.to_i,
                                  lat: req.params[:lat],
                                  lon: req.params[:lon] })

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
