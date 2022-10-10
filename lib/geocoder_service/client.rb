module GeocoderService
  class Client
    include Dry::Monads[:result, :try, :do]

    extend Dry::Initializer[undefined: false]

    DEFAULT_URL = "http://localhost:3003/geocoder/v1".freeze

    option :connection, default: proc { Container["faraday.connection"] }
    option :url, default: proc { Settings.geocoder.base_url || DEFAULT_URL }
  end
end
