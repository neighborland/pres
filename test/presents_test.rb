require "test_helper"

describe Pres::Presents do
  class Doge
  end

  class DogePresenter < Pres::Presenter
  end

  class VeryDogePresenter < Pres::Presenter
  end

  class FakeController
    include Pres::Presents

    # Expose the private method
    # Basically what `helper_method :present` does
    def present(*args, &block)
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
    presenter = controller.present(Doge.new)
    assert presenter.is_a?(DogePresenter)
  end

  it "yields the default presenter" do
    controller.present(Doge.new) do |doge|
      assert doge.is_a?(DogePresenter)
    end
  end

  it "creates the specified presenter" do
    presenter = controller.very_wrap(Doge.new)
    assert presenter.is_a?(VeryDogePresenter)
  end

  it "yields the specified presenter" do
    controller.very_wrap(Doge.new) do |doge|
      assert doge.is_a?(VeryDogePresenter)
    end
  end

  it "creates an array of default presenters" do
    presenters = controller.present([Doge.new, Doge.new])
    assert presenters.is_a?(Array)
    assert_equal 2, presenters.size
    assert presenters[0].is_a?(DogePresenter)
  end

  it "creates an array of specified presenters" do
    presenters = controller.very_wrap([Doge.new, Doge.new])
    assert presenters.is_a?(Array)
    assert_equal 2, presenters.size
    assert presenters[0].is_a?(VeryDogePresenter)
  end

  it "creates the default presenter for nil object" do
    presenter = controller.present(nil)
    assert presenter.is_a?(Pres::Presenter)
  end
end
