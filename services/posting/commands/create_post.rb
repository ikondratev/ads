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
        yield encode_location(params[:city], create_result.user_id)

        Success(:done)
      rescue StandardError => e
        puts "[CreatePost] message: #{e.message}"
        Failure([:creation_error])
      end

      private

      def create_post(params)
        l "Commands::CreatePost", action: :create_post, params: params

        Success(ads_repo.create(params))
      rescue StandardError => e
        le "Commands::CreatePost", e.message
        Failure([:creation_error])
      end

      def encode_location(city, post_id)
        l "Commands::CreatePost", action: :encode_location, city: city, post_id: post_id

        Success(geocoder_client.geocoding(city, post_id))
      rescue StoreError => e
        le "Commands::CreatePost", e.message
        Failure([:encode_location_error])
      end
    end
  end
end
