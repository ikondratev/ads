module GeocoderService
  module API
    class EncodeLocation < GeocoderService::Client
      include Import[
                validation: "validations.encode_location",
                i18n: "locales.i18n"
              ]
      # @param [String] city
      # @return [Integer] user_id
      def call(city)
        validated_params = yield validation.call(city: city)
        response = yield geocoder_request(validated_params[:city])
        lat, lon = yield parse_response(response)

        Success([lat, lon])
      end

      private

      def geocoder_request(city)
        Try[StandardError] do
          result = @connection.post(@url) do |request|
            request.params[:city] = city
          end

          raise StandardError unless result.success?

          result
        end.to_result.or(
          Failure([:bad_request])
        )
      end

      def parse_response(response)
        Try[StandardError] do
          encode_city_params = response.body.dig(:meta, :encode)

          encode_city_params.each do |param|
            raise StandardError if param.nil?
          end

          encode_city_params
        end.to_result.or(
          Failure([:empty_response])
        )
      end
    end
  end
end
