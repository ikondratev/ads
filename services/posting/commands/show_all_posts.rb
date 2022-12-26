module Posting
  module Commands
    class ShowAllPosts
      include Dry::Monads[:result]

      def call
        l "[#{self.class.name}]: started"
        Success(Posting::Models::Ad.all)
      rescue StandardError => e
        le "[#{self.class.name}]", e.message
        Failure([:show_error])
      end
    end
  end
end
