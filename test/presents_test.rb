# frozen_string_literal: true

require "test_helper"

class Dogg
end

class DoggPresenter < Pres::Presenter
end

class SnoopDoggPresenter < Pres::Presenter
end

class NateDogg
  def presenter_class
    SnoopDoggPresenter
  end
end

class FakeController
  include Pres::Presents

  # Expose the private method
  # Basically what `helper_method :present` does
  def present(*args, **kwargs, &)
    super
  end

  def very_wrap(object, &)
    present(object, presenter: SnoopDoggPresenter, &)
  end

  def view_context
    FakeViewContext.new
  end
end

describe Pres::Presents do
  let(:controller) { FakeController.new }

  it "creates the default presenter" do
    assert_instance_of DoggPresenter, controller.present(Dogg.new)
  end

  it "yields the default presenter" do
    controller.present(Dogg.new) do |dogg|
      assert_instance_of DoggPresenter, dogg
    end
  end

  it "creates the specified presenter" do
    assert_instance_of SnoopDoggPresenter, controller.very_wrap(Dogg.new)
  end

  it "yields the specified presenter" do
    controller.very_wrap(Dogg.new) do |dogg|
      assert_instance_of SnoopDoggPresenter, dogg
    end
  end

  it "creates an array of default presenters" do
    presenters = controller.present([Dogg.new, Dogg.new])
    assert_instance_of Array, presenters
    assert_equal 2, presenters.size
    assert_instance_of DoggPresenter, presenters[0]
  end

  it "creates an array of specified presenters" do
    presenters = controller.very_wrap([Dogg.new, Dogg.new])
    assert_instance_of Array, presenters
    assert_equal 2, presenters.size
    assert_instance_of SnoopDoggPresenter, presenters[0]
  end

  it "creates the default presenter for nil object" do
    assert_instance_of Pres::Presenter, controller.present(nil)
  end

  it "creates an instance of object's presenter_class" do
    assert_instance_of SnoopDoggPresenter, controller.present(NateDogg.new)
  end

  it "yields an instance of object's presenter_class" do
    controller.present(NateDogg.new) do |dogg|
      assert_instance_of SnoopDoggPresenter, dogg
    end
  end
end
