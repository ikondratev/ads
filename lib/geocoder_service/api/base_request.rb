module GeocoderService
  module API
    class BaseRequest
      include Dry::Monads[:result, :try, :do]

      extend Dry::Initializer[undefined: false]

      AVAILABLE_METHODS = { post: "post", get: "get", put: "put", delete: "delete" }.freeze
      DEFAULT_URL = "http://localhost:3003/geocoder/v1".freeze

      option :connection, default: proc { Container["faraday.connection"] }
      option :base_url, default: proc { Settings.geocoder.base_url || DEFAULT_URL }
      option :headers, default: proc { {} }
      option :params, default: proc { {} }

      protected

      def request(method, url)
        raise "undefined method" unless AVAILABLE_METHODS[method]

        @connection.send(method, "#{@base_url}#{url}", @params, @headers)
      end
    end
  end
end
