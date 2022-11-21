module Posting
  module Commands
    class UpdateCoordinates
      include Dry::Monads[:result, :try, :do]

      include Import[
                ads_repo: "services.posting.repositories.ads_repo",
                validation: "validations.update_coordinates"
              ]

      UPDATED_PARAMS = %i[lat lon].freeze

      # @param [Hash] payload
      def call(payload)
        params = yield validation.call(payload)
        yield update_post(params)

        Success(true)
      end

      private

      def update_post(params)
        l "Commands::UpdateCoordinates", action: :update_post, params: params

        Success(
          # ad.update_fields(params, %i[lon lat])
          ads_repo.update_by_id(
            params[:post_id],
            { lon: params[:lon], lat: params[:lat] }
          )
        )
      rescue StoreError => e
        le "Commands::UpdateCoordinates", e.message
        Failure([:update_coordinates_error])
      end
    end
  end
end
