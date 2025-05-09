# `pres`

[![Gem Version](https://badge.fury.io/rb/pres.svg)](http://badge.fury.io/rb/pres)
[![Build Status](https://github.com/neighborland/pres/actions/workflows/ruby.yml/badge.svg)](https://github.com/neighborland/pres/actions/workflows/ruby.yml)

## What?

A Presenter is a rendering class. The `pres` gem is a lightweight presenter
solution with no runtime gem dependencies.

`Pres` provides the following:

1. `Pres::Presenter` is a presenter base class.
1. `present` is a convenience method to create presenters.
1. `Pres::ViewDelegation` is a delegation module, included in the `Presenter` base class.

## How and Why?

Presenters are an alternative to an unorganized pile of helper methods in your rails application.

Rails' `ViewContext` contains convenience methods for views, such as `link_to`,
`url_for`, `truncate`, `number_to_currency`, etc. It's the thing that makes
Rails views nice to work with.

Other presenter libraries mix in all the methods from the Rails `ViewContext` to
make it easy to call those methods in the Presenter class. `pres` instead injects
the `ViewContext` as a dependency into the Presenter class, and uses `method_missing`
to delegate to `ViewContext` methods. `pres` produces small classes that contain and
delegate to an existing object that handles server-side rendering.

## Install

Add it to your Gemfile:

```ruby
gem "pres"
```

## Setup with Rails

Include the `Pres::Presents` module:

```ruby
class ApplicationHelper
  include Pres::Presents
end
```

This will make the `present` method available in your views.

## Use

There are two main approaches:

(1) Follow the traditional rails way with view templates, but move your helper methods into a presenter class.
You'll probably want to start here if you have an existing rails app.

(2) Create self-contained rendering components (see "Components" below).

You can use both techniques.

### (1) With View Templates

The quickest way to get started is to use the `Pres::Presenter` base class.

Create a presenter class in `app/presenters`:

```ruby
class DoggPresenter < Pres::Presenter
  # explicitly delegate methods to the model
  delegate :name, to: :object

  def info_link
    # Rails helpers are available via the view context
    link_to "Snoop Dogg", "https://en.wikipedia.org/wiki/Snoop_Dogg"
  end

  def name_header
    # object is the Dogg used to initialize the presenter
    content_tag(:h1, object.name)
  end

  def signed_in_status
    # controller methods are accessible via the view context
    if signed_in?
      "Signed in"
    else
      "Signed out"
    end
  end
end
```

Standard rails controller method:

```ruby
class DoggsController
  def show
    @dogg = Dogg.find(params[:id])
  end
end
```

Wrap your model object in a presenter in your view with `present`:

`doggs/show.haml.html`

```haml
- present(@dogg) do |dogg|
  = dogg.name_header
  .status
    You are #{dogg.signed_in_status}
  .links
    .meme-link= dogg.info_link
```

#### Collections

Standard rails controller method:

```ruby
class DoggsController
  def index
    @doggs = present(Dogg.all)
  end
end
```

Build an array of presenters in your view with `present`:

`doggs/index.haml.html`

This renders "doggs/\_dogg.html.haml" for each item, following rails' usual conventions:

```haml
= render present(@doggs)
```

Or use each:

```haml
- present(@doggs).each do |dogg|
  = dogg.name_header
```

## (2) Components

You can use `pres` to build components that directly render HTML:

_Note: `#sanitize` is a method on the `view_context`._

```ruby
class NameHeader < Pres::Presenter
  def render
    return unless object&.name
    <<~HTML.html_safe
      <h1>#{sanitize(object.name.titleize)}</h1>
    HTML
  end
end

user = User.new(name: "joe cool <")

NameHeader.new(user, view_context).render
=> "<h1>Joe Cool &lt;</h1>"

present(user, presenter: NameHeader).render
=> "<h1>Joe Cool &lt;</h1>"
```

You may notice that you could do without `pres` altogether when you don't need
the `view_context` helper methods:

```ruby
class PlusTwo
  def initialize(object)
    @object = object
  end

  def render
    return unless @object
    <<~HTML.html_safe
      <p>#{@object + 2}</p>
    HTML
  end
end

PlusTwo.new(2).render
=> "<p>4</p>"

present(2, presenter: PlusTwo).render
=> "<p>4</p>"
```

If `render` is confusing, name that method `#to_html` or something else.

## Options

#### Present with options

Pass additional options to a Presenter as a hash. The presenter class exposes the
`options` hash as a method:

```ruby
user = User.new

# These two lines are the same:
# 1. explicit
presenter = UserPresenter.new(user, view_context, something: 123)

# 2. using #present
presenter = present(user, something: 123)
=> #<UserPresenter object: #<User> ...>

presenter.options[:something]
=> 123
```

#### Use a custom presenter class

By default, a presenter class corresponding to the model class name is
constructed in `present`. For example, if you present a `User`, a `UserPresenter`
class is constructed. An error is raised if the presenter class does not exist.
To specify a different class, use the `presenter:` key.

```ruby
user = User.new
present(user, presenter: UserEditPresenter, cool: true)
=> #<UserEditPresenter object: #<User> ...>
```

You may also define a custom presenter class on any class you want to present:

```ruby
class User
  def presenter_class
    MyPresenter
  end
end

present(User.new)
# => #<MyPresenter object: #<User> ...>
```

#### Presenters can create other presenters

Presenters can wrap child objects in presenters of their own.

```ruby
class DoggPresenter < Pres::Presenter
  def cats
    present(object.cats)
  end
end
```

```haml
= render dogg.cats
```

### Using mixins instead of inheritance

If you don't want to inherit from `Pres::Presenter`, you can include
`Pres::ViewDelegation` and implement your own initializer (so the `present` helper
will work).

This technique is useful if you would like to delegate all methods in a model
by default, instead of whitelisting methods on the wrapped model explicitly.
Delegating everything to the model by default is how the `draper` gem works, for example.

```ruby
class DoggPresenter < DelegateClass(Dogg)
  include Pres::ViewDelegation

  def initialize(object, view_context, options = {})
    super(object)
    @view_context = view_context
  end
```

```haml
= dogg.name
```

see [DelegateClass](https://ruby-doc.org/stdlib-2.4.0/libdoc/delegate/rdoc/Object.html)

## Updating to version 1.0

Modules and classes have been moved into the `Pres` namespace with version 1.0.
Change your code references to `Pres::Presents` and `Pres::Presenter`.

## References

- http://nithinbekal.com/posts/rails-presenters/
- https://github.com/drapergem/draper
- http://thepugautomatic.com/2014/03/draper/
- https://robots.thoughtbot.com/sandi-metz-rules-for-developers
