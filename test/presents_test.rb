require "test_helper"

describe Presents do
  class Doge
  end

  class DogePresenter < Presenter
  end

  class VeryDogePresenter < Presenter
  end

  class FakeController
    include Presents

    def wrap(object)
      present(object)
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
    presenter = controller.wrap(Doge.new)
    assert presenter.is_a?(DogePresenter)
  end

  it "creates the specified presenter" do
    presenter = controller.very_wrap(Doge.new)
    assert presenter.is_a?(VeryDogePresenter)
  end

  it "creates an array of default presenters" do
    presenters = controller.wrap([Doge.new, Doge.new])
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
    presenter = controller.wrap(nil)
    assert presenter.is_a?(Presenter)
  end
end
