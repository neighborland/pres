module Pres
  module ViewDelegation
    extend ActiveSupport::Concern

    included do
      attr_reader :view_context
    end

    # Send missing symbols to view_context first
    def method_missing(symbol, *args, &block)
      if view_context.respond_to?(symbol, true)
        view_context.send(symbol, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(symbol, _ = false)
      view_context.respond_to?(symbol, true) || super
    end
  end
end
