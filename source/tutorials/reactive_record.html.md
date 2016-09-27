## Using Reactrb Reactive Record

[The source code to this tutorial is here](https://github.com/barriehadfield/reactrb-showcase)

Reactive Record compiles your Active Record models so they are accessible to the front-end and implements an API based on your models and their associations. Lazy loads just the data that is needed to render a component and is fully integrated with Reactrb and paired with Synchromesh to push database changes to all connected clients. ReactiveRecord and Synchromesh give you Relay + GraphQL like functionality with a fraction of the effort and complexity (the original idea for Reactive Record is credited to [Volt](https://github.com/voltrb/volt) and not Relay).

### Installing Reactive Record

Installing Reactive Record is straight forward.

First add this line to your application's Gemfile:

```ruby
gem 'reactive-record'
```

And then execute:

```
$ bundle install
```

Finally you need to add a line to your `routes.rb`:

```ruby
mount ReactiveRecord::Engine => '/rr'
```

### Creating the models

We are going to need a few models to work with so let's go ahead and create those now.

```text
rails g model Post
rails g model Comment post:references
```

And then before you run the migrations, lets flesh them out a little so they look like this:

```ruby
# db/migrate/..create_posts.rb
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :body
      t.timestamps null: false
    end
  end
end

# db/migrate/..create_comments.rb
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post, index: true, foreign_key: true
      t.string :body
      t.timestamps null: false
    end
  end
end
```

Now would be a good time to run the migrations:

```text
rake db:migrate
```

### Making your models accessible to Reactive Record

Reactive Record needs to 'see' your models as a representation of them get compiled into JavaScript along with your Reactrb components so they are accessible in your client side code.

The convention (though this is choice and you can change this if you prefer) is to create a `public` folder under `models` and then provide a linkage file which will `require_tree` your models when compiling `components.rb`.

Create a new folder:

```text
models/public
```

Then move `post.rb` and `comment.rb` to `models/public`

```text
$ mv app/models/post.rb app/models/public
$ mv app/models/comment.rb app/models/public
```

Next create `_react_public_models.rb` in your models folder:

```ruby
# models/_react_public_models.rb
require_tree './public'
```

Finally add a line to your `views/components.rb` file:

```ruby
# views/components.rb
...
require '_react_public_models'
```

### Model Associations

Reactive Record is particular about both sides of an association being specified. If you forget to do this you will see warnings to this effect.

```ruby
# models/public/post.rb
class Post < ActiveRecord::Base
  has_many :comments
end

# models/public/comment.rb
class Comment < ActiveRecord::Base
  belongs_to :post
end
```

### Accessing your models in Reactrb components

To get started, lets create a new component which will display a list of Posts and Comments under the video:

```ruby
# views/components/show.rb
...
div.container do
  ReactPlayer(url: 'https://www.youtube.com/embed/FzCsDVfPQqk', playing: true)
  br # line break
  PostsList()
end
...
```

Note that to place a Reactrb component you either need to include ( ) or { }, so `PostsList()` or `PostsList { }` would be valid but just `PostsList` would not.

Next lets create the `PostsList` component:

```ruby
module Components
  module Home
    class PostsList < React::Component::Base
      define_state :new_post, ""

      before_mount do
        # note that this will lazy load posts
        # and only the fields that are needed will be requested
        @posts = Post.all
      end

      def render
        div do
          new_post
          ul.list_unstyled do
            @posts.reverse.each do |post|
              PostListItem(post: post)
              CommentsList(comments: post.comments)
            end
          end
        end
      end

      def new_post
        ReactBootstrap::FormGroup() do
          ReactBootstrap::FormControl(
            value: state.new_post,
            type: :text,
          ).on(:change) { |e|
            state.new_post! e.target.value
          }
        end
        ReactBootstrap::Button(bsStyle: :primary) do
          "Post"
        end.on(:click) { save_new_post }
      end

      def save_new_post
        post = Post.new(body: state.new_post)
        post.save do |result|
          # note that save is a promise so this code will only run after the save
          # yet react will move onto the code after this (before the save happens)
          alert "unable to save" unless result == true
        end
        state.new_post! ""
      end
    end

    class PostListItem < React::Component::Base
      param :post

      def render
        li do
          # note how you access post.body just like with Active Record
          h4 { params.post.body }
        end
      end

    end
  end
end
```

Things to note in the code above:

See how we fetch the Reactive Record Post collection in `before_mount`. Setting this here instead of in `after_mount` means that we do not need to worry about `@posts` being `nil` as the collection will always contain at least one entry with the actual records being lazy loaded when needed.

Note how we are binding the state variable `new_post` to the `FormControl` and then setting its value based on the value being passed to the `.on(:change)` block. This is a standard React pattern.

Also see how we are saving the new post where Reactive Record's save returns a promise which means that the block after save is only evaluated when it returns yet React would have moved on to the rest of the code.

Finally note that there is no code which checks to see if there are new posts yet when you run this, the list of posts remains magically up-to-date.

Welcome to the wonderful of Reactive Record and React!
