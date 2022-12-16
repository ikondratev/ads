module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result]

      def call
        l "Commands::ShowAllPosts"
        Success(Posting::Models::Ad.all)
      rescue StandardError => e
        le "Commands::ShowAllPosts", e.message
        Failure([:show_error])
      end
    end
  end
end
