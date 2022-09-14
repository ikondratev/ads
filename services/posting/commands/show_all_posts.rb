module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result]

      include Import[ads_repo: "services.posting.repositories.ads"]

      def call
        ads = ads_repo.all

        Success(ads)
      end
    end
  end
end
