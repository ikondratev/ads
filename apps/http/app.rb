require "hanami/api"
require "hanami/middleware/body_parser"
require "hanami/action"

module HTTP
  class App < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get "/ping" do
      "PONG"
    end

    get "/", to: Container["http.actions.commands.show_all_ads"]
  end
end
