module Posting
  module Types
    include Dry.Types()

    UserId = Integer.optional
    Title = String.constrained(min_size: 5)
    Description = String.constrained(max_size: 50)
  end
end
