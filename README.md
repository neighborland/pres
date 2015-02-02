# `pres`

[![Gem Version](https://badge.fury.io/rb/pres.svg)](http://badge.fury.io/rb/pres)
[![Build Status](https://travis-ci.org/neighborland/pres.svg)](https://travis-ci.org/neighborland/pres)

## What?

A Presenter is a rendering class that wraps a model. Presenters are an
alternative to an unorganized mass of helper methods in your Rails application.

The `pres` gem is a lightweight presenter solution.

## How and Why?

Decorators add methods to a model. `pres` does not do that. `pres` encourages you
to whitelist model methods (via delegation).

Other presenter libraries mix in all the methods from the Rails ViewContext to
make it easy to call those methods in the Presenter class. This causes method
bloat. `pres` instead injects the ViewContext as a dependency into the
Presenter class, and uses `method_missing` to delegate to those methods.

## Install

Add it to your Gemfile:

```ruby
gem "pres"
```

Include the `Presents` module:

```ruby
class ApplicationController
  include Presents
end
```

Add `app/presenters` to your application's autoload paths in `application.rb`:

```ruby
config.autoload_paths += %W( #{ config.root }/app/presenters )
```

#### Example Usage

Create a presenter class in `app/presenters`:

```ruby
class DogePresenter < Presenter
  # explicitly delegate methods to the model
  delegate :name, to: :object

  def know_your_meme_link
    # Rails helpers are available via the view context
    link_to "Know your meme", "http://knowyourmeme.com/memes/doge"
  end

  def name_header
    # object is the Doge
    content_tag(:h1, objec†.name)  
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
  
  helper_method :doge
  
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

#### Collection Example

Create a presenter class in `app/presenters`:

```ruby
class DogePresenter < Presenter
  # same as above
end
```

Wrap your model object in your controller with `present`:

```ruby
class DogesController
  def index
  end

  private

  helper_method :doges

  def doges
    @doges ||= present(Doge.all)
  end  
end
```

Use the presenter objects in `doges/index.haml.html`

```haml
This renders "doges/_doge.html.haml" for each item, as usual:
= render @doges

Or use each:
- doges.each do |doge|
  = doge.name_header
```

#### Present with options

Use keyword arguements (or an options hash) to pass additional options to a
Presenter:

```ruby
class UserPresenter
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
constructed. To specify a different class, pass the `presenter:` key, followed
by any additional arguments:

```ruby
user = User.new
present(user, presenter: NiceUserPresenter, cool: true)
=> #<NiceUserPresenter object: #<User> ...>
```

#### Render a collection

```ruby
present(User.first(5))
=> [#<UserPresenter object: #<User> ...>]
```

#### Creating presenters in views

You should create presenters in your controllers. If you would like to create
a presenter in your view code, make the `presents` method visible to your views:

```ruby
class ApplicationController
  include Presents
  helper_method :present
end
```

## More Goodness

#### Presenters are objects

You can mix in common methods. Move everything in `application_helper.rb` to
`app/presenters/shared`:

```ruby
module Shared
  def logout_link
    # whatever
  end
end

class DogePresenter < Presenter
  include Shared
end
```

You can override methods without resorting to convoluted method names:

```ruby
class DogePresenter < Presenter
  include Shared

  def logout_link
    # whoa this one is different!
  end
end
```

#### Presenters can create other presenters

```ruby
class DogePresenter < Presenter
  def cats
    present(object.cats)
  end  
end
```

```haml
= render doge.cats
```

## References

* http://nithinbekal.com/posts/rails-presenters/
* https://github.com/drapergem/draper
