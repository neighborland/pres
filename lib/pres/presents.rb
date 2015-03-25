module Presents
  private

  # Wrap an object or collection of objects with a presenter class.
  #
  # object    - a ruby class, or nil
  # presenter - a Presenter class (optional)
  #
  # Examples
  #
  # user = User.new
  # present(user, cool: true)
  # => #<UserPresenter object: #<User> ...>
  #
  # user = User.new
  # present(user, presenter: NiceUserPresenter, cool: true)
  # => #<NiceUserPresenter object: #<User> ...>
  #
  # present([user])
  # => [#<UserPresenter object: #<User> ...>]
  #
  # present(nil)
  # => [#<Presenter object: nil ...>]
  #
  # Returns a new Presenter object or array of new Presenter objects
  def present(object, presenter: nil, **args)
    if object.respond_to?(:to_ary)
      object.map { |item| present(item, presenter: presenter, **args) }
    else
      presenter ||= Presenter if object.nil?
      presenter ||= Object.const_get("#{ object.class.name }Presenter")
      presenter.new(object, view_context, **args)
    end
  end
end
