module AuthService
  module HTTP
    module API
      REQUEST_URL = "/".freeze
      # @param [String] token
      # @return [Hash] result
      def auth(token)
        result = @connection.post("#{@base_url}#{REQUEST_URL}") do |request|
          request.headers["Authorization"] = "#{token}"
        end

        return Failure([:bad_request]) unless result.success?

        user_id = result.body.dig("meta", "user_id")

        user_id.nil? ? Failure([:bad_request]) : Success(user_id: user_id)
      rescue StandardError => e
        puts "[API::AUTH] error: #{e.message}"
        Failure([:internal_error])
      end
    end
  end
end
