# Base Presenter class
# Construct with object, view_context, and optional options
class Presenter < Struct.new(:object, :view_context, :options)
  delegate :id, :to_partial_path, to: :object

  # Send missing symbols to view_context
  def method_missing(symbol, *args, &block)
    view_context.send(symbol, *args, &block)
  end

  def respond_to?(symbol, _ = false)
    super || view_context.respond_to?(symbol, true)
  end
end
