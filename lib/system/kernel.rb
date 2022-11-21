module System
  module Kernel
    # @param [String] description
    # @param [Hash] opts
    def l(description, **opts)
      Container["app.logger"].info(description, opts)
    end

    # @param [Sting] description
    # @param [Array<String>] error_messages
    def le(description, *error_messages)
      Container["app.logger"].error(description, error_messages: error_messages)
    end
  end
end
