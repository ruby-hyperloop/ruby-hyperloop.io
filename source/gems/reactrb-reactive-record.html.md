---
title: Hyper Record Gem
---
# Hyper Record

Github: [Reactive Record](https://github.com/reactrb/reactive-record)

Reactive Record is a client-side representation of your Active Record models fully integrated with Reactrb. Reactive Record works perfectly with Synchromesh to magically synchronise server side data changes with any connected client. Writing simple code, without worrying about how data moves between one machine and another, and then seeing live updates in action is magical.

#### Reactive Record gives you Active Record models on the client integrated with Reactrb.

You do nothing to your current Active Record models except move them to the models/public directory (so they are compiled on the client as well as the server.)

* Fully integrated with [Reactrb](https://github.com/reactrb/reactrb) (which is React with a beautiful Ruby DSL).
* Paired with [Synchromesh](https://github.com/reactrb/synchromesh) to magically push server-side data changes to all authorised clients displaying that data.
* Takes advantage of React prerendering, and afterwards additional data is *lazy loaded* as it is needed by the client.
* Supports full CRUD access using standard Active Record features, including associations, aggregations, and errors.
* Uses model based authorization mechanism for security similar to [Hobo](http://www.hobocentral.net/manual/permissions) or [Pundit](https://github.com/elabs/pundit).
* Models and even methods within models can be selectively implemented server-side only.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'reactive-record'
```
And then execute:
```text
$ bundle install
```
Finally you need to add a line to your 'routes.rb':
```ruby
mount ReactiveRecord::Engine => '/rr'
```

### Models

Reactive Record creates a client side (JavaScript) representation of your Active Record models. This representation can be taken directly from your existing models or if you prefer you can maintain a seperate version of your models (a public version). In this example we will keep the models we want Reactive Record to see in  `models/public` and `require` this into `components.rb` so it is compiled to JavaScript and available to our client code..

Create a new folder:
```text
models/public
```
Then create `_react_public_models.rb` in your `models` folder:
```ruby
# models/_react_public_models.rb
require_tree './public'
```
And then add a line to your `views/components.rb` file:
```ruby
# views/components.rb
require '_react_public_models'
```
And that is all the setup you need. Any Active Record models you place in the `models/public` folder will be avalable to you client-side Reactrb code as it they were on the client.

## Usage

Let's assume you have two Active Record models which we have placed in your `models/public` folder so they can be seen by Reactive Record:

```ruby
# models/public/post.rb
class Post < ActiveRecord::Base
  has_many :comments
end
```
```ruby
# models/public/comments.rb
class Comment < ActiveRecord::Base
  belongs_to :post
end
```
Note that Reactive Record is less permissive than Active Record so it is important that you explicitly define both ends of an association (`has_many` must always have an associated `belongs_to`).

Let's create a simple Reactrb component that renders a list of all posts and their associated comments:

```ruby
# views/components/post_with_comments_list.rb
class PostsWithCommentsList < React::Component::Base

  before_mount do
    @posts = Post.all
  end

  def render
    ul do
      @posts.each do |post|
        li { post.title }
        ul do
          post.comments.each do |comment|
            li { comment.body }
          end
        end
      end
    end
  end
end
```
Note that with Reactive Record ` @posts = Post.all` is set in `before_mount` whereas if you were using a a REST based `GET` you would have done so in `after_mount`. Setting the value of `@posts` in `before_mount` means you do not have to worry about nil values while prerendering. The actual query to the server is not initiated at this stage, but when the component is rendering.

## Live updates via Synchromesh

[Synchromesh](https://github.com/reactrb/synchromesh) if fully integrated with Reactive Record. Changes in records are broadcast (after filtering for security) to the clients and Reactrb updates the page if and only if the user is viewing a component containing data that has changed.

To have the component we have written above remain fully in synch with the database and automatically update if any new posts or comments are added to the database, all we need to do is use Reactrb state:
```ruby
# views/components/post_with_comments_list.rb
class PostsWithCommentsList < React::Component::Base

  before_mount do
    # define the Post collection as state
    state.posts! Post.all
  end

  def render
    ul do
      # and remember to use state here
      state.posts.each do |post|
        li { post.title }
        ul do
          post.comments.each do |comment|
            li { comment.body }
          end
        end
      end
    end
  end
end
```
That's it! You need no additional code to ensure your data remains updated between all authrozed clients displaying that data.

See [Synchromesh](https://github.com/reactrb/synchromesh) for how scopes are used to affect the current rendered output from models which are joined to the model being rendered.

## How it works

Reactive Record uses your existing Active Record models (or a copy thereof) which are compiled to JavaScript and made available on the client. You can consider these to be a public version (or API) of your models.

 Its all about lazy loading. Reactive Record lazy loads data from the server as and when it is required on the client. This prevents us from grabbing enormous association collections, or large attributes unless they are explicitly requested.

During prerendering we get each attribute as its requested and fill it in both on the javascript side, as well as remember that the attribute needs to be part of the download to client.

On the client we fill in the record data with empty values (nil, or one element collections) but only as the attribute is requested.  Each request queues up a request to get the real data from the server.

The ReactiveRecord class serves two purposes.  First it is the unique data corresponding to the last known state of a database record.  This means All records matching a specific database record are unique.  This is unlike AR but is important both for the lazy loading and also so that when values change react can be informed of the change.

Secondly it serves as name space for all the ReactiveRecord specific methods, so every AR Instance has a ReactiveRecord

Because there is no point in generating a new ar_instance everytime a search is made we cache the first ar_instance created. Its possible however during loading to create a new ar_instances that will in the end point to the same record.

Vectors are an important concept.  They are the substitute for a primary key before a record is loaded. Vectors have the form [ModelClass, method_call, method_call, method_call...]

Each method call is either a simple method name or an array in the form [method_name, param, param ...]

Example `[User, [find, 123], todos, active, [due, "1/1/2016"], title]`

Roughly corresponds to this query:

`User.find(123).todos.active.due("1/1/2016").select(:title)`


## Help and support

Head on over to [gitter.im](https://gitter.im/reactrb/chat) to ask any questions you might have!

[![Join the chat at https://gitter.im/catprintlabs/reactive-record](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/reactrb/chat?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Code Climate](https://codeclimate.com/github/reactrb/reactive-record/badges/gpa.svg)](https://codeclimate.com/github/reactrb/reactive-record)
[![Gem Version](https://badge.fury.io/rb/reactive-record.svg)](https://badge.fury.io/rb/reactive-record)

For an example applcation see [reactrb todo](https://reactiverb-todo.herokuapp.com/) (live demo [here.](https://reactiverb-todo.herokuapp.com/))

## Notes
* Reactive Record >= 0.8.x depends on the reactrb gem.  You must [upgrade to reactrb](https://github.com/reactrb/reactrb#upgrading-to-reactrb)

* Therubyracer has been removed as a dependency to allow the possibility of using other JS runtimes. Please make sure if you're upgrading that you have it (or another runtime) required in your gemfile.

* We have dropped suppport for the ability to have rails load the same Class *automatically* from two different files, one with server side code, and one with client side code. If you need this functionality load the following code to your config/application.rb file.  However we found from experience that this was very confusing, and you are better off to explicitly include modules as needed.

```ruby
module ::ActiveRecord
  module Core
    module ClassMethods
      def inherited(child_class)
        begin
          file = Rails.root.join('app','models',
            "#{child_class.name.underscore}.rb").to_s rescue nil
          begin
            require file
          rescue LoadError
          end
          # from active record:
          child_class.initialize_find_by_cache
        rescue
        end # if File.exist?(Rails.root.join('app', 'view', 'models.rb'))
        super
      end
    end
  end
end
```

## Running tests
The test suite runs in opal on a rails server, so the test database is actually the test_app's dev database.

* ```cd spec/test_app```
* ```rake db:reset``` (to prepare the "test" database)
* ```rails s```
* visit localhost:3000/spec-opal to run the suite.
Note: If any tests fail when running the entire suite, there is a good possibility that you will need to run ```rake db:reset``` to fix the database before running the tests again.

## Contributions

This project is still in early stage, so discussion, bug reports and PRs are really welcome 😉.

## License

In short, Reactive Record is available under the MIT license. See the LICENSE file for more info.
