module Posting
  module Commands
    class CreatePost
      include Dry::Monads[:result, :try, :do]

      include Import[
                ads_repo: "services.posting.repositories.ads_repo",
                validation: "validations.create_payload",
                location: "geocoder_service.api.encode_location"
              ]

      # @param [Hash] payload
      # @return [Dry::Monad] result
      def call(payload)
        params = yield validation.call(payload)
        geocodes = yield encode_location(params[:city])
        create_result = yield create_post(params, geocodes)

        Success(create_result)
      end

      private

      def create_post(params, geocodes)
        Try[StandardError] do
          params.merge!(lat: geocodes["lat"], lon: geocodes["lon"])
          ads_repo.create(params)
          :done
        end.to_result.or(
          Failure([:creation_error])
        )
      end

      def encode_location(city)
        Try[StandardError] do
          result = location.call(city)

          raise StandardError unless result.success?

          result.success
        end.to_result.or(
          Failure([:encode_location_error])
        )
      end
    end
  end
end
