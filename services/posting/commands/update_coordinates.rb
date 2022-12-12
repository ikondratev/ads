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
        Try[StandardError] do
          ad = Posting::Models::Ad.find(id: params[:post_id])
          ad.update_fields(params, %i[lon lat])
        end.to_result.or(
          Failure([:update_params_error])
        )
      end
    end
  end
end
