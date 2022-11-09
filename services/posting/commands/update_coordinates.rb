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

        Success
      end

      private

      def update_post(params)
        Try[StandardError] do
          # post = ads_repo.find_by_id(params[:post_id])
          # post.merge!(lat: params[:lat], lon: params[:lon])
          ads_repo.update_by_id(params[:post_id], { lon: params[:lon], lat: params[:lat] })
        end.to_result.or(
          Failure([:update_params_error])
        )
      end
    end
  end
end
