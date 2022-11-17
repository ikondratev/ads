require "hanami/api"
require "hanami/middleware/body_parser"
require "hanami/action"

module HTTP
  class AdsController < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get "/", to: Container["http.actions.commands.show_all_ads"]

    post "/create", to: Container["http.actions.commands.create_post"]

    post "/:id/update_coordinates", to: Container["http.actions.commands.update_coordinates"]
  end
end
