module Posting
  module Commands
    class CreatePost
      include Dry::Monads[:result, :try, :do]

      include Import[
                ads_repo: "services.posting.repositories.ads_repo",
                validation: "validations.create_payload"
              ]

      # @param [Hash] payload
      # @return [Dry::Monad] result
      def call(payload)
        params = yield validation.call(payload)
        create_result = yield create_post(params)

        Success(create_result)
      end

      private

      def create_post(params)
        Try[StandardError] do
          ads_repo.create(params)
          :done
        end.to_result.or(
          Failure([:creation_error])
        )
      end
    end
  end
end
