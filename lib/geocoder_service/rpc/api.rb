module GeocoderService
  module Rpc
    module Api
      # @param [String] city
      # @param [Integer] post_id
      def geocoding(city, post_id)
        l "GeocoderService:RPC::API", action: :geocoding, city: city, post_id: post_id

        payload = { city: city, post_id: post_id }.to_json
        publish(payload, type: "geocoding")
      rescue StandardError => e
        le "GeocoderService:RPC::API", e.message
      end
    end
  end
end
