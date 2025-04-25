# frozen_string_literal: true

require "test_helper"

describe Pres::Presenter do
  it "delegates to view_context" do
    view_context = FakeViewContext.new
    presenter = Pres::Presenter.new(nil, view_context)
    assert presenter.respond_to?(:current_user)
    assert presenter.respond_to?(:link_to)
    assert_equal "<a href='x'>X</a>", presenter.link_to("something")
  end

  it "is constructed without options" do
    assert Pres::Presenter.new(nil, nil)
  end

  it "is constructed without view_context" do
    assert Pres::Presenter.new(nil)
  end

  it "is constructed with options" do
    presenter = Pres::Presenter.new(nil, nil, something: 42, secrets: "none")
    assert_equal 42, presenter.options[:something]
    assert_equal "none", presenter.options[:secrets]
  end

  it "can create other presenters" do
    presenter = Pres::Presenter.new(nil)
    assert presenter.respond_to?(:present, true)
  end

  it "#inspect with object" do
    object = Object.new
    presenter = Pres::Presenter.new(object)
    assert_equal "#{object.inspect}\noptions: {}\nview_context: NilClass",
                 presenter.inspect
  end

  it "#inspect with options" do
    object = Object.new
    presenter = Pres::Presenter.new(object, nil, name: "x")
    expect_inspect = if RUBY_VERSION >= "3.4"
                       %(#{object.inspect}\noptions: {name: "x"}\nview_context: NilClass)
                     else
                       %(#{object.inspect}\noptions: {:name=>"x"}\nview_context: NilClass)
                     end
    assert_equal expect_inspect, presenter.inspect
  end

  it "#inspect with view_context" do
    object = Object.new
    view_context = { abc: 123 }
    presenter = Pres::Presenter.new(object, view_context)
    assert_equal "#{object.inspect}\noptions: {}\nview_context: Hash",
                 presenter.inspect
  end
end
