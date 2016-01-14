module Pres
  module ViewDelegation
    extend ActiveSupport::Concern

    included do
      attr_reader :view_context
    end

    # Send missing symbols to view_context
    def method_missing(symbol, *args, &block)
      view_context.send(symbol, *args, &block)
    end

    def respond_to_missing?(symbol, _ = false)
      super || view_context.respond_to?(symbol, true)
    end
  end
end
