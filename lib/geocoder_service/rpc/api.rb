module GeocoderService
  module Rpc
    module Api
      def geocoding(city, post_id)
        payload = { city: city, post_id: post_id }.to_json
        publish(payload, type: "geocoding")
      end
    end
  end
end
