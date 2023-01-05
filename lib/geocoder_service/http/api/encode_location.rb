module GeocoderService
  module HTTP
    module API
      class EncodeLocation < GeocoderService::HTTP::API::BaseRequest
        include Import[
                  validation: "validations.encode_location",
                  extractor: "geocoder_service.http.api.extractors.encode_location_extractor",
                  i18n: "locales.i18n"
                ]
        REQUEST_URL = "/".freeze
        # @param [String] city
        # @return [Integer] user_id
        def call(city)
          l "started", city: city
          validated_params = yield validation.call(city: city)
          response = yield geocoder_request(validated_params[:city])
          geocodes = yield parse_response(response)

          Success(geocodes)
        end

        private

        def geocoder_request(city)
          l "geocode request", action: :geocoder_request, city: city
          @params = { "city": city }
          result = request(:post, REQUEST_URL)
          result.success? ? Success(result) : Failure(result)
        end

        def parse_response(response)
          Try[GeocoderService::HTTP::API::Extractors::ExtractorError] do
            extractor.call(response)
          end.to_result.or(
            Failure([:empty_response])
          )
        end
      end
    end
  end
end
