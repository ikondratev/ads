module GeocoderService
  module API
    class EncodeLocation < GeocoderService::Client
      include Import[
                validation: "validations.encode_location",
                i18n: "locales.i18n"
              ]
      REQUEST_URL = "/".freeze
      # @param [String] city
      # @return [Integer] user_id
      def call(city)
        validated_params = yield validation.call(city: city)
        response = yield geocoder_request(validated_params[:city])
        geocodes = yield parse_response(response)

        Success(geocodes)
      end

      private

      def geocoder_request(city)
        Try[StandardError] do
          result = @connection.post("#{@base_url}#{REQUEST_URL}") do |request|
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
          encode_city_params = response.body.dig("meta", "encode")

          raise StandardError if encode_city_params.empty?
          raise StandardError if encode_city_params.values.any?(&:nil?)

          encode_city_params
        end.to_result.or(
          Failure([:empty_response])
        )
      end
    end
  end
end
