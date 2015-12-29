# Base Presenter class
# Construct with object, view_context, and optional options
class Presenter
  attr_accessor :object, :options, :view_context

  delegate :id, :to_partial_path, to: :object

  def initialize(object, view_context = nil, options = {})
    self.object = object
    self.view_context = view_context
    self.options = options
  end

  # Send missing symbols to view_context
  def method_missing(symbol, *args, &block)
    view_context.send(symbol, *args, &block)
  end

  def respond_to?(symbol, _ = false)
    super || view_context.respond_to?(symbol, true)
  end
end
