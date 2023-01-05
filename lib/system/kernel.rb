module System
  module Kernel
    # @param [String] description
    # @param [Hash] opts
    def l(description = nil, **opts)
      opts.merge!(class_name: self.class.name)
      Container["app.logger"].info(description, opts)
    end

    # @param [Sting] description
    # @param [StandardError] error
    def le(description, error, **opts)
      opts.merge!(class_name: self.class.name)
      opts.merge!(class_error: error.class.name)
      opts.merge!(error_message: error.message)
      Container["app.logger"].error(description, opts)
    end
  end
end
