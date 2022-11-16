module Posting
  module Commands
    class CreatePost
      include Dry::Monads[:result, :try, :do]

      include Import[
                ads_repo: "services.posting.repositories.ads_repo",
                validation: "validations.create_payload",
                geocoder_client: "geocoder_service.rpc.client"
              ]

      # @param [Hash] payload
      # @return [Dry::Monad] result
      def call(payload)
        params = yield validation.call(payload)
        create_result = yield create_post(params)
        yield encode_location(params[:city], create_result)

        Success(:done)
      end

      private

      def create_post(params)
        Try[StandardError] do
          ads_repo.create(params)
        end.to_result.or(
          Failure([:creation_error])
        )
      end

      def encode_location(city, post_id)
        Try[StandardError] do
          geocoder_client.geocoding(city, post_id)
        end.to_result.or(
          Failure([:encode_location_error])
        )
      end
    end
  end
end
