module AuthService
  module API
    class AuthUser < AuthService::Client
      include Import[
                validation: "validations.auth_user",
                i18n: "locales.i18n"
              ]
      # @param [String] token
      # @return [Integer] user_id
      REQUEST_URL = "/".freeze
      def call(token)
        validated_params = yield validation.call(barier: token)
        auth_response = yield auth_request(validated_params[:token])
        user_id = yield extract_user_id(auth_response)

        Success(user_id: user_id)
      end

      private

      def auth_request(token)
        Try[StandardError] do
          result = @connection.post("#{@base_url}#{REQUEST_URL}") do |request|
            request.headers["Authorization"] = "#{token}"
          end

          raise StandardError unless result.success?

          result
        end.to_result.or(
          Failure([:bad_request])
        )
      end

      def extract_user_id(auth_response)
        Try[StandardError] do
          user_id = auth_response.body.dig("meta", "user_id")

          raise StandardError unless user_id

          user_id
        end.to_result.or(
          Failure([:forbidden_error])
        )
      end
    end
  end
end
