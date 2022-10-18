require_relative "api"

module AuthService
  class Client
    include Dry::Monads[:result]
    include API

    extend Dry::Initializer[undefined: false]

    DEFAULT_URL = "http://localhost:3003/auth/v1".freeze

    option :connection, default: proc { Container["faraday.connection"] }
    option :base_url, default: proc { Settings.auth.base_url || DEFAULT_URL }
  end
end
