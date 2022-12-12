module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result, :try, :do]

      def call
        ads = yield find_posts
        Success(ads)
      end

      private

      def find_posts
        Try[StandardError] do
          Posting::Models::Ad.all
        end.to_result.or(Failure([:show_error]))
      end
    end
  end
end
