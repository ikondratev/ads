module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result]
      include Import[
                ads_repo: "services.posting.repositories.ads_repo"
              ]

      def call
        l "Commands::ShowAllPosts"

        Success(ads_repo.all)
      rescue StandardError => e
        le "Commands::ShowAllPosts", e.message
        Failure([:show_error])
      end
    end
  end
end
