require "hanami/api"
require "hanami/middleware/body_parser"
require "hanami/action"

module HTTP
  class App < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get "/ping" do
      "PONG"
    end
  end
end
