module Posting
  module Commands
    class UpdateCoordinates
      include Dry::Monads[:result, :try, :do]
      include Import[
                validation: "validations.update_coordinates"
              ]
      UPDATED_PARAMS = %i[lat lon].freeze
      # @param [Hash] payload
      def call(payload)
        l "[#{self.class.name}]:", payload: payload
        params = yield validation.call(payload)
        yield update_post(params)

        Success(true)
      end

      private

      def update_post(params)
        l "#{self.class.name}", action: :update_post, params: params
        ad = Posting::Models::Ad.find(id: params[:post_id])
        Success(ad.update_fields(params, %i[lon lat]))
      rescue StandardError => e
        le "#{self.class.name}", e.message
        Failure([:update_coordinates_error])
      end
    end
  end
end
