module GeocoderService
  module HTTP
    module API
      module Extractors
        class ExtractorError < StandardError; end
        class EncodeLocationExtractor
          # @param [Faraday::Response] response
          # @return [Hash] result
          # @raise [ExtractorError] error
          def call(response)
            encode_city_params = response&.body&.dig("meta", "encode")

            raise "empty response" if encode_city_params.nil?
            raise "one of fields was empty" if encode_city_params.values.any?(&:nil?)

            encode_city_params
          rescue StandardError => e
            puts "[Extractors::EncodeLocationExtractor] error: #{e.message}"
            raise ExtractorError, e.message
          end
        end
      end
    end
  end
end
