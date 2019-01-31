# frozen_string_literal: true

# Base Presenter class
# Construct with object, view_context, and optional options
module Pres
  class Presenter
    include Presents
    include ViewDelegation

    attr_reader :object, :options

    def initialize(object, view_context = nil, options = {})
      @object = object
      @view_context = view_context
      @options = options
    end

    def id
      object.id
    end

    def to_partial_path
      object.to_partial_path
    end

    def inspect
      [
        object.inspect,
        "options: #{options.inspect}",
        "view_context: #{view_context.class.name}"
      ].join("\n")
    end
  end
end
