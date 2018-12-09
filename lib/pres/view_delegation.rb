# frozen_string_literal: true

module Pres
  module ViewDelegation
    def view_context
      @view_context
    end

    # Send missing methods to view_context first
    def method_missing(method, *args, &block)
      if view_context.respond_to?(method, true)
        view_context.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, _ = false)
      view_context.respond_to?(method, true) || super
    end
  end
end
