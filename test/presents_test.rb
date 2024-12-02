# frozen_string_literal: true

require "test_helper"

describe Pres::Presents do
  class Doge
  end

  class DogePresenter < Pres::Presenter
  end

  class VeryDogePresenter < Pres::Presenter
  end

  class SuchDoge
    def presenter_class
      VeryDogePresenter
    end
  end

  class FakeController
    include Pres::Presents

    # Expose the private method
    # Basically what `helper_method :present` does
    def present(*args, **kwargs, &)
      super
    end

    def very_wrap(object)
      present(object, presenter: VeryDogePresenter)
    end

    def view_context
      FakeViewContext.new
    end
  end

  let(:controller) { FakeController.new }

  it "creates the default presenter" do
    assert_instance_of DogePresenter, controller.present(Doge.new)
  end

  it "yields the default presenter" do
    controller.present(Doge.new) do |doge|
      assert_instance_of DogePresenter, doge
    end
  end

  it "creates the specified presenter" do
    assert_instance_of VeryDogePresenter, controller.very_wrap(Doge.new)
  end

  it "yields the specified presenter" do
    controller.very_wrap(Doge.new) do |doge|
      assert_instance_of VeryDogePresenter, doge
    end
  end

  it "creates an array of default presenters" do
    presenters = controller.present([Doge.new, Doge.new])
    assert_instance_of Array, presenters
    assert_equal 2, presenters.size
    assert_instance_of DogePresenter, presenters[0]
  end

  it "creates an array of specified presenters" do
    presenters = controller.very_wrap([Doge.new, Doge.new])
    assert_instance_of Array, presenters
    assert_equal 2, presenters.size
    assert_instance_of VeryDogePresenter, presenters[0]
  end

  it "creates the default presenter for nil object" do
    assert_instance_of Pres::Presenter, controller.present(nil)
  end

  it "creates an instance of object's presenter_class" do
    assert_instance_of VeryDogePresenter, controller.present(SuchDoge.new)
  end

  it "yields an instance of object's presenter_class" do
    controller.present(SuchDoge.new) do |doge|
      assert_instance_of VeryDogePresenter, doge
    end
  end
end
