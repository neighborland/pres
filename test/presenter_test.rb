require "test_helper"

describe Presenter do
  it "delegates to view_context" do
    view_context = FakeViewContext.new
    presenter = Presenter.new(nil, view_context)
    assert presenter.respond_to?(:current_user)
    assert presenter.respond_to?(:link_to)
    view_context.expects(:link_to)
    presenter.link_to "something"
  end

  it "is constructed without options" do
    assert Presenter.new(nil, nil)
  end

  it "is constructed with options" do
    presenter = Presenter.new(nil, nil, something: 42, secrets: "none")
    assert_equal 42, presenter.options[:something]
    assert_equal "none", presenter.options[:secrets]
  end
end
