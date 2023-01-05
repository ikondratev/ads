module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result]

      def call
        l "started"
        Success(Posting::Models::Ad.all)
      rescue StandardError => e
        le "Error show posts", e
        Failure([:show_error])
      end
    end
  end
end
