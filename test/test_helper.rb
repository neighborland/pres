if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "minitest/autorun"
require "byebug" if ENV["BYEBUG"]
require "pres"

class FakeViewContext
  # An example of a method mixed into the view_context
  def current_user
    nil
  end

  private

  # An example of a private method provided by the view_context
  def link_to(*_)
    "yay"
  end
end
