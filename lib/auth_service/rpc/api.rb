module AuthService
  module Rpc
    module API
      def auth(token)
        payload = { token: token }.to_json

        start
        publish(payload, type: "token")

        raise "User wasn't authorize" if @user_id.nil?

        Success(user_id: @user_id)
      rescue StandardError => e
        puts "[RPC::API::AUTH] error: #{e.message}"
        Failure([:forbidden_error])
      end
    end
  end
end
