# `pres`

[![Gem Version](https://badge.fury.io/rb/pres.svg)](http://badge.fury.io/rb/pres)
[![Build Status](https://travis-ci.org/neighborland/pres.svg)](https://travis-ci.org/neighborland/pres)

## What?

A Presenter is a rendering class. Presenters are an alternative to an unorganized mass of helper 
methods in your Rails application. The `pres` gem is a lightweight presenter solution.

## How and Why?

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

Include the `Pres::Presents` module:

```ruby
class ApplicationController
  include Pres::Presents
end
```

### Usage

The quickest way to get started is to use the `Pres::Presenter` base class.

Create a presenter class in `app/presenters`:

```ruby
class DogePresenter < Pres::Presenter
  # explicitly delegate methods to the model
  delegate :name, to: :object

  def know_your_meme_link
    # Rails helpers are available via the view context
    link_to "Know your meme", "http://knowyourmeme.com/memes/doge"
  end

  def name_header
    # object is the Doge
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

Wrap your model object in your controller with `present`:

```ruby
class DogesController
  def show
  end

  private

  helper_method \
  def doge
    @doge ||= present(Doge.find(params[:id]))
  end  
end
```

Use the presenter object in `doges/show.haml.html`

```haml
= doge.name_header
.status
  You are #{ doge.signed_in_status }
.links
  .meme-link= doge.know_your_meme_link
```

#### Collections

Create a presenter class in `app/presenters`:

```ruby
class DogePresenter < Pres::Presenter
  # same as above
end
```

Wrap your model objects in your controller with `present`:

```ruby
class DogesController
  def index
  end

  private

  helper_method \
  def doges
    @doges ||= present(Doge.all)
  end  
end
```

Use the presenter objects in `doges/index.haml.html`

This renders "doges/_doge.html.haml" for each item, as usual:

```haml
= render @doges
```

Or use each:

```haml
- doges.each do |doge|
  = doge.name_header
```

#### Present with options

Pass additional options to a Presenter as a hash:

```ruby
class UserPresenter < Pres::Presenter
  def initialize(object, view_context, cool: false)
    super
    @cool = cool
  end  
end

user = User.new
present(user, cool: true)
=> #<UserPresenter object: #<User> ...>
```

#### Render a custom Presenter

By default, a presenter class corresponding to the model class name is
constructed in `present`. For example, if you present a `User`, a `UserPresenter`
class is constructed. An error is raised if the presenter class does not exist. 
To specify a different class, use the `presenter:` key.

```ruby
user = User.new
present(user, presenter: UserEditPresenter, cool: true)
=> #<UserEditPresenter object: #<User> ...>
```

#### Creating presenters in views

If you would like to create a presenter in your view code, make the `present` method 
visible to your views.

```ruby
class ApplicationController
  include Pres::Presents
  helper_method :present
end
```

This makes it easy to create presenters inline in a view:

```haml
- present(@doge) do |doge|
  = doge.name_header
```

### Presenters are objects

You can mix in common methods.

```ruby
module Shared
  def truncated_name(length: 40)
    truncate object.name, length: length
  end
end

class DogePresenter < Pres::Presenter
  include Shared
end
```

You can override methods as usual:

```ruby
class DogePresenter < Pres::Presenter
  include Shared

  def truncated_name(length: 60)
    # whoa this one is different!
    super(length: length)
  end
end
```

#### Presenters can create other presenters

If you are awesome, you could have one top-level presenter exposed per controller,
which can then wrap child objects in presenters of their own.

```ruby
class DogePresenter < Pres::Presenter
  def cats
    present(object.cats)
  end  
end
```

```haml
= render doge.cats
```

### Using mixins instead of inheritance

If you don't want to inherit from `Pres::Presenter`, you can include
`Pres::ViewDelegation` and implement your own initializer (so the `present` helper
will work). 

This technique is useful if you would like to delegate all methods in a model
by default, instead of whitelisting methods on the wrapped model explicitly.
Delegating everything to the model by default is how the `draper` gem works, for example.

```ruby
class DogePresenter < SimpleDelegator
  include Pres::ViewDelegation

  # you need to write your own initializer with SimpleDelegator
  def initialize(object, view_context, options = {})
    super
    @view_context = view_context
  end
```

```haml
= doge.name
```

see [SimpleDelegator](http://ruby-doc.org/stdlib-2.3.0/libdoc/delegate/rdoc/SimpleDelegator.html)

## Updating to version 1.0

Modules and classes have been moved into the `Pres` namespace with version 1.0.
Change your code references to `Pres::Presents` and `Pres::Presenter`.

## References

* http://nithinbekal.com/posts/rails-presenters/
* https://github.com/drapergem/draper
* http://thepugautomatic.com/2014/03/draper/
* https://robots.thoughtbot.com/sandi-metz-rules-for-developers
