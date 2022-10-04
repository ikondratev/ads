module AuthService
  module API
    class AuthUser < AuthService::Client
      # @param [String] token
      def call(token)
        auth_response = yield auth_request(token)
        user_id = yield extract_user_id(auth_response)

        Success(user_id)
      end

      private

      def auth_request(token)
        Try[StandardError] do
          result = @connection.post(@url) do |request|
            request.headers["Authorization"] = "Barier #{token}"
          end

          raise StandardError unless result.success?

          result
        end.to_result.or(
          Failure([:bad_request, { error_message: "bad request" }])
        )
      end

      def extract_user_id(auth_response)
        Try[StandardError] do
          user_id = auth_response.body.dig(:meta, :user_id)

          raise StandardError if user_id

          user_id
        end.to_result.or(
          Failure([:forbidden_error, { error_message: "user not found" }])
        )
      end
    end
  end
end
