# frozen_string_literal: true

if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "minitest/autorun"
require "byebug" if ENV["BYEBUG"]
require "pres"

class FakeViewContext
  # A method mixed into the view_context
  def current_user
    nil
  end

  private

  # A private method provided by the view_context
  def link_to(*_)
    "<a href='x'>X</a>"
  end
end
