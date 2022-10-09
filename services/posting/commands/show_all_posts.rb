module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result, :try, :do]

      include Import[ads_repo: "services.posting.repositories.ads_repo"]

      def call
        ads = yield find_posts

        Success(ads)
      end

      private

      def find_posts
        Try[StandardError] do
          ads_repo.all
        end.to_result.or(
          Failure([:show_error])
        )
      end
    end
  end
end
