# Base Presenter class
# Construct with object, view_context, and optional options
module Pres
  class Presenter
    extend Forwardable
    include Presents
    include ViewDelegation

    attr_reader :object, :options

    def_delegators :object, :id, :to_partial_path

    def initialize(object, view_context = nil, options = {})
      @object = object
      @view_context = view_context
      @options = options
    end
  end
end
