module AuthService
  module Rpc
    module API
      # @param [String] token
      # @return [Dry::Monad]
      def auth(token)
        l "[#{self.class.name}]", action: :auth, token: token
        payload = { token: token }.to_json
        start
        publish(payload, type: "token")

        raise "User wasn't authorize" if @user_id.nil?

        Success(user_id: @user_id)
      rescue StandardError => e
        le "[#{self.class.name}]", e.message
        Failure([:forbidden_error])
      end
    end
  end
end
