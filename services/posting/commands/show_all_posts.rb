module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result, :try, :do]

      include Import[ads_repo: "services.posting.repositories.ads_repo"]

      def call
        ads = yield show_posts

        Success(ads)
      end

      private

      def show_posts
        Try[StandardError] do
          ads_repo.all
        end.to_result.or(
          Failure([:show_error, { error_message: "show action was failed" }])
        )
      end
    end
  end
end
