module GeocoderService
  module Rpc
    module Api
      # @param [String] city
      # @param [Integer] post_id
      def geocoding(city, post_id)
        l "started", action: :geocoding, city: city, post_id: post_id

        payload = { city: city, post_id: post_id }.to_json
        publish(payload, type: "geocoding")
      rescue StandardError => e
        le "Error geocoding", e
      end
    end
  end
end
