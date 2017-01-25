---
title: Chat App Tutorial
---
## HyperReact Chat-App Tutorial

We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.  

We will be building the app from the ground up, but if you want to see the [final source code it is here](#source-code-of-the-steps-up-until-detecting-loged-in-user)

[The final app is here](/tutorials/chat_app_source)

Our Chat app will provide:

* A login window to register your chat handle
* A view of the current chat conversation
* An input box to submit a chat

It will also have a few neat features:

* **Live updates:** other users' chats are popped into the conversation view in real time.
* **Dynamic Time Formatting:** the time format changes as that chat ages.
* **Markdown formatting:** users can use Markdown to format their text.
* **Uses Bootstrap:** for styling

### Let's Get Started!

1. open up a file named `chatrb.html` (or whatever you want)
2. copy in the following content and save it.  
3. point your browser to `file://...your directory path.../chatrb.html` and you should see the current time.

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Hello React</title>
    <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/0.3.5/marked.min.js"></script>
    <script src="https://rawgit.com/reactrb/reactrb-express/master/reactrb-express.js"></script>
    <script src="http://ruby-hyperloop.io/javascripts/test_chat_service.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

    <style type="text/css">
      /* most styles will come from bootstrap, but we will be adding a
        few extra styles here */
    </style>

    <script type="text/ruby">
      # Our ruby code will go here.  For now lets use a simple component
      # to make sure things are working.  For the rest of the tutorial
      # all the code we write will go in this section.
      class App < React::Component::Base
        before_mount { @timer = every(1) { force_update! } }
        def render
          "The current time is #{Time.now}"
        end
      end  
    </script>
  </head>
  <body>
    <!-- Tell inline reactive ruby to mount App here -->
    <div data-reactrb-mount="App"></div>
  </body>
</html>
```

### Application Structure

React is all about modular, composable components. For our chat app, we'll have the following structure which will be mirrored by 6 corresponding Reactrb components:

```
App
  Nav
  Messages
    Message
      FormattedDiv
    Message
      FormattedDiv
    ... repeat for each ... message
  InputBox
    FormattedDiv
```

Each component will render the corresponding portion of the UI and is described by a Ruby class that inherits from React::Component::Base.

Let's stub out all of classes right now.  Replace the contents inside  the
`<script type="text/ruby">...</script>` tag with the following ruby code.

```ruby
class App < React::Component::Base
  def render
    div do
      Nav()
      Messages()
      InputBox()
    end
  end
end

class Nav < React::Component::Base
  def render
    div {"Our Nav Bar Goes Here including a login box"}
  end
end

class Messages < React::Component::Base
  def render
    # eventually we will loop and display each message
    # for now we will just display one as an example
    Message()
  end
end

class Message < React::Component::Base
  def render
    FormattedDiv()
  end
end

class InputBox < React::Component::Base
  def render
    div do
      "An input box to send new messages will".br
      "go here plus a display of the formatted markdown".br
      FormattedDiv()
    end
  end
end

class FormattedDiv < React::Component::Base
  def render
    "convert and display markdown"
  end
end
```

Refresh your page, and you should see this:

```
Our Nav Bar Goes Here including a login box
convert and display markdown
An input box to send new messages will
go here plus a display of the formatted markdown
convert and display markdown
```

Before going on lets understand the basic features of the Reactrb DSL

- #### Every component has a `render` method

    Each component is a class that inherits from `React::Component::Base` and defines a `render` method.

- #### The `render` method must generate a single `React::Element`  

    Look at the `App` component: it wraps its three *children* in a `div`.  If you forgot this wrapper `div` you would get this error in the browser's javascript console:

    ```
    RuntimeError: a components render method must generate and return exactly 1 element or a string
    ```

- #### HTML tags are Ruby methods

    Within the `render` method each html tag has a corresponding Ruby method.  Each of these methods generates a single `React::Element`, which contains component type plus parameters, plus any nested elements.  

    All HTML tags have lower case names matching their HTML counter parts.

- #### Application components also define Ruby methods

    You generate a `Message` component by calling the `Message()` method

    Because the component class and the component method share the same name you must include either (possibly empty) parenthesis, or block literal following the component name, so Ruby knows you mean to call a method.

    `Message  ` <- a class name
    `Message()` <- generate a `Message` element.

- #### By default strings are wrapped by `span` tags

    Now go all the way down to the `FormattedDiv` component.  If a string appears as the last expression (the returned value) of either a render method or a component's block, the string is wrapped in a `span` as if you had typed `span { "some string" }`.

- #### Strings also respond to `br, span, para, th` and `td`

    Strings also respond to several element generating methods: `br, span, para` (for `p`), `td` and `th`.  Again this is just short hand, so `"foo".td` is short for `td { "foo" }`

### Adding Parameters

Components have parameters just like methods.  Now that we have the basic App structure, understanding a component's params is a good next step.  Lets start by adding the `markdown` parameter to the `FormattedDiv` component.

Update the `Message, InputBox` and `FormattedDiv` components so they look like this:

```ruby
class Message < React::Component::Base

  def render
    FormattedDiv(markdown: "This **Markdown** will eventually be a message")
  end
end

class InputBox < React::Component::Base
  def render
    div do
      "An input box to send new messages will".br
      "go here plus a display of the formatted markdown".br
      FormattedDiv(markdown: "This **Markdown** will get updated as the user types")
    end
  end
end

class FormattedDiv < React::Component::Base

  param :markdown, type: String

  def render
    div do
      params.markdown
    end
  end
end
```

- #### The `param` *macro* describes the *inputs* to a component.

    In our case the `FormattedDiv` component will *receive* the `markdown` param from either the
    `Message` or `InputBox` components.  

- #### Params can have an optional type.

    In our case we declare `markdown` to be a `String`.  If the incoming parameter does not match the type a warning will be displayed on the console.  While typing your params is optional its highly recommended.

- #### Params are accessed using the `params` object.

    Each `param` you declare in a component will have a corresponding method on the `params` object.  Component parameters are accessible by any instance method within your component using the `params` object.  

### Adding An Event Handler

Our application will need to respond to three types of events:

+ A user logs in
+ A user sends a chat
+ Receiving chat messages.

We will start by adding a basic user login handler.

We decided up front that the login box will be part of the top nav bar, so that is where we will add it:

```ruby
class Nav < React::Component::Base

  def render
    div do
      input(class: :handle, type: :text, placeholder: "Enter Your Handle")
      button(type: :button) { "login!" }.on(:click) do
        alert("#{Element['input.handle'].value} logs in!")
      end
    end
  end

end
```

Replace the `Nav` component with the above code, and refresh your browser.  You should now be able to "login".

Things to notice:

- #### Event handlers are attached to any element using the `on` method.

    The `on` method takes the event name and a block.  The block is called when the event occurs.

- #### Tag attributes are passed just like params.

    `input(class: :handle, type: :text, placeholder: "Enter Your Handle")`  
    generates  
    `<input class="handle", type="text", placeholder="Enter Your Handle" />`

- #### Strings and Symbols are the same type in Opal.

    For effeciency the Opal-Ruby transpiler treats Ruby symbols as strings.  So  
    `:text == 'text'`

- #### `Element` is the Opal-Ruby jQuery compatible wrapper.

    `Element['input.handle'].value` translates to `$('input.handle').value()`  
    Be aware that `React::Element` which we refer to as *elements* through out the tutorial is not the same as Opal's `Element` wrapper.

### Adding State

Our improved `Nav` component is still pretty dull, and having to directly access the DOM using `Element` is not a great idea either.

To add some intelligence to our `Nav` component it needs *state*.  Reactrb provides *state variables* that work like *reactive* instance variables.  When a state variable is updated, it will cause components to re-render.  

We are going to add two state variables to our component:  `current_user_name` and `user_name_input`.  

`current_user_name` is either `nil` (meaning there is no valid user name) or contains the user name string.

`user_name_input` will track the user name as it is typed allowing us to dynamically update the UI based on what the user has typed.

```ruby
class Nav < React::Component::Base

  before_mount do
    state.current_user_name! nil
    state.user_name_input! ""
  end

  def render
    div do
      input(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
      ).on(:change) do |e|
        state.user_name_input! e.target.value
      end
      button(type: :button) { "login!" }.on(:click) do
        login!
      end if valid_new_input?
    end
  end

  def valid_new_input?
    state.user_name_input.present? && state.user_name_input != state.current_user_name
  end

  def login!
    state.current_user_name! state.user_name_input
    puts "*** #{state.current_user_name} has logged in"
  end

end
```

Once again, update the `Nav` component, and make sure it works.  

Things to notice:

- #### State variables are accessed through the `state` object.

    Each state variable has a read and write accessor on the state object.  The
    write accessor ends with a "!" to remind you that this method will update state
    and cause re-rendering of the component.

- #### There is no *assignment* method for state variables.

    There are several reasons for this, that we will discuss later, but for now you can
    consider the write accessor (or bang method) to be equivalent to assignment.

- #### Initialize state in the `before_mount` callback.

    The `before_mount` *lifecycle* callback is called after `params` are first initialized, but before
    render is called, so its the place to initialize your state variables.

    More on the *lifecycle* callbacks later.

- #### Event handlers are passed the event object

    As each character is typed we use the event object to update `state.user_name_input`.  

    Besides giving us dynamic access to the state of the user input as its changing, `state.user_name_input` also frees us from having to tag and interrogate DOM objects directly.

- #### As state changes, the component will rerender.

    For example the login button is only rendered if there is valid new input.

    In React you think declaratively about the UI.  At any point in time the
    `render` method simply draws the UI based on params and the current state of the
    component.  As the component state changes, or when it receives new params, `render`
    is called to deliver the updated UI.

    Under the hood React.js has efficient algorithms to insure that the minimum DOM
    update is performed.

- #### Use helper methods to keep `render` simple.

    For example we created the `is_valid_new_input?` method, and moved the login logic to the `login!` method.

    This helps to understand the core logic and layout of the `render` method.

- #### The `puts` method logs on the js debug console

### Talking to Your Parents

We will add some other nice features  of our `Nav` component later but right now we need to think about what happens when the user logs in.

We don't want to clutter up our `Nav` component with this logic so we need some way to communicate that we have a new user name upwards to the parent.

There are quite a few different ways to do this, depending on your specific needs.  A straight forward way is for the parent to provide a *callback* that the `Nav` component will use to signal that a new user has logged in.  

Add the following `param` declaration at the top of the `Nav` component:

```ruby
  param :login, type: Proc
```

and update the `login!` method so it looks like this:

```ruby
  def login!
    state.current_user_name! state.user_name_input
    params.login(state.user_name_input)
  end
```

Again reload your browser and try logging in.  You will notice in the console that there is a new warning:

```console
Warning: Failed propType: In component `Nav`
Required prop `login` was not specified Check the render method of `App`.
```

Which makes sense, as we specified that `Nav` wants a `login` parameter, but `App` did not provide one.  

Lets go ahead and add the callback to the `App` component.  Add the following method to the bottom of the `App`:

```ruby
  def login(user_name)
    puts "*** #{user_name} has logged in"
  end
```

and pass the `login` method to the `Nav` component like so

```ruby
  def render
    Nav(login: method(:login).to_proc)
    ...
  end
```

Reload your browser, and login, and the warning will be gone, and the login message will be back.

Lets review these changes:

- #### Callbacks are a simple way to communicate upwards

    As we will see there are other mechanisms which are often more appropriate but in this case a call back `Proc` is the perfect solution.  

    To implement a callback you declare the param type as `Proc`.  This tells the `params` object to treat the param as a method call, rather than just returning its value.  

    Meanwhile in the parent component you will need to pass a `Proc` to the component.  Ruby lets you create and access `Proc`s in several ways, in our case we converted the instance method `login` to a `Proc` using `method`.

- #### React takes the approach of warning vs. errors when things go wrong

    The good thing is this allows you some wiggle room as you are building and testing your components.

    The downside is that you need to keep an eye on the console log, and find and remove unexpected warnings.

Before we go on note that this is an example application.  In a real world app we would probably
not use this mechanism for logging on.  A real login component would need to check credentials and would
have additional state to track and report the progress of the login process.

### The Chat Service

Now that we can login, its time to understand the chat service. Lucky for us Heroku already has a demo chat application that we will use.  **Thanks Heroku!**  To keep things focused on React, we have already included a Ruby wrapper that our application will use.

To access the Chat Service we create a new instance of the `ChatService` like this:

```ruby
  chat = ChatService.new do | messages |
    # After a user logs in, a (possibly empty) initial
    # array of current messages will be sent to this block.
    # As new messages arrive the block will be called again.  
  end
```

The object returned by `ChatService.new` has three methods:  `login, id` and `send`.

```ruby
  chat.login("LukeS") # login user "LukeS" - for our simple app no password is Required
  chat.id             # returns the current id (i.e. "LukeS")
  chat.send(message)  # sends message to everybody (including the sender)
```

What the message contains is completely up to us.  We will be sending hashes containing the sender's handle,
the message string, and the time that the message was sent:

```ruby
  chat.send({handle: ..., message: ..., time: Time.now})
```

And finally the authors of our `ChatService` class have provided us with a test service preloaded with a set of messages in our chosen format.  We are already including this version in our header.

Armed with this, we are ready to start displaying chat messages.

### Lifecycle Callbacks

A react component has a well defined life cycle, and your components can hook into the lifecycle using the callback macros.  In our application we will use three of the most common callbacks `before_mount, after_mount` and `after_update`.  

Each call back takes a block or the name of a method, which will be called as the component passes through each stage in its lifecycle.

When our App starts (**mounts** in React terms) we need to initialize the chat service.

Add this code to the beginning of the `App` component:

```ruby
  before_mount do
    ChatService.new do | messages |
      if state.messages
        state.messages! state.messages + messages
      else
        state.messages! messages
      end
      puts "state messages updated.  state.messages: #{state.messages}"
    end
  end
```

Before the component mounts our callback will execute and it creates a new `ChatService` instance.  

As each new set of messages arrives the block will execute which will initialize or append the messages to the `state.messages` state variable.  We know we want to make this a state variable since it clearly is going to change asynchronously overtime, and we will want to update the UI when that occurs.

Refresh your browser, and make sure nothing is broken, but notice nothing is changing.  *Why Not?* - because we have not logged in yet.

### Instance and State Variables

Okay so while we can initialize the chat service when `App` mounts, nothing will happen until the user logs in.  

We have our login method already defined, so we just want to change it so that it passes the login to the chat service.  To do this we have to save the chat service object in the `before_mount` callback so that we can use it in the `login` method.

Change the `before_mount` callback to be:

```ruby
  before_mount do
    @chat_service = ChatService.new do | messages |
      state.messages! ((state.messages || []) + messages)
      puts "state messages updated.  state.messages: #{state.messages}"
    end
  end
```

Now that we have saved our new `ChatService` object in `@chat_service` we can use it in the `login` method like this:

```ruby
  def login(user_name)
    @chat_service.login(user_name)
  end
```

With this in place refresh your browser, and watch the console as you login.  You should see an array of messages that looks like this:

```console
state messages updated.  state.messages: {"from"=>"user1", "time"=>1449089985, "message"=>"A 2 point message: \n+ point 1\n+ point 2\nGot it?"},{"from"=>"user2", "time"=>1449262785, "message"=>"message sent 8 days ago, by user 2"},{"from"=>"user3", "time"=>1449521985, "message"=>"message sent in the last week"},{"from"=>"user2", "time"=>1449608385, "message"=>"message sent **also** in the last week"},{"from"=>"user1", "time"=>1449950385, "message"=>"Was sent within the last hour!"},{"from"=>"user2", "time"=>1449952185, "message"=>"Was sent 30 minutes ago"},{"from"=>"user3", "time"=>1449953385, "message"=>"Was just sent\n\n\n\n\n\n\n\n\nwith a lot of blanks"},{"from"=>"user1", "time"=>1449953985, "message"=>"just now"}
```

There is an important point here:

- #### Not everything has to be a state variable

    `@chat_service` is an instance variable, while `state.messages` is a state variable.

    We can see that as time passes new messages will come in, and we will want to re-render when this happens.  This led us to define `messages` as a state variable.  Because `messages` is a state variable as it changes re-rendering of the App component will automatically occur.

    But so far we have no reason to make `@chat_service` into a state variable, so we use a plain old instance variable.

    For our simple component the messages themselves are the only state we care about.

    We will come back to this discussion as we flesh out the rest of our application.

Now that we are logging in, connecting to the (test) chat service and updating our `messages` state variable, we are ready to display those messages.

Hopefully by this time you've got a rough idea how we are going to do this!

First update the `App` render method like this:

```ruby
  def render
    div do
      Nav login: method(:login).to_proc
      Messages messages: state.messages
      InputBox()
    end
  end
```

Then add the corresponding `messages` parameter to the `Messages` component:

```ruby
  param :messages, type: [Hash]
```

And update the `Messages` render method to iterate through all the messages displaying `Message` for each one:

```ruby
  def render
    div do
      params.messages.each do |message|
        Message message: message
      end
    end
  end
```

Likewise the `Message` component needs to receive and display a message.  Replace the whole component with the following:

```ruby
class Message < React::Component::Base

  param :message, type: Hash

  def render
    div do
      div { params.message[:from] }
      FormattedDiv markdown: params.message[:message]
      div { Time.at(params.message[:time]).to_s }
    end
  end
end
```

Save everything, and refresh your browser.  Login and you should see a very rough but functional display of your messages!

- #### Array type params

    Notice how we declared the `messages` param as type `[Hash]` this notation means "Array of Hash".

    You can also say `type: []` which means array of anything and is shorthand for `type: Array`.

### Some Cleanup

Take a look at the console log, and you will see a big red error like this:

`Exception raised while rendering #<Messages:0x16fa>`  
`    NoMethodError: undefined method 'each' for nil`

Lets think about this.  When we first render `Messages`, there are no messages, so trying to send `each` to `nil` fails.

One nice thing about React is that it is very robust.  Even though we had this error, things still work.  Once we are logged in, we do have messages, and everything worked.

Anyway we need to fix this!  Add the following method to the bottom of the `App` class:

```ruby
  def online?
    state.messages
  end
```

For our simple App we are going to figure that we are logged in **if** `state.messages` is not `nil`.  

Now update the `App`s `render` method so that we don't display the `Messages` or the `InputBox` unless we are logged in.

```ruby
  def render
    div do
      Nav login: method(:login).to_proc
      if online?
        Messages messages: state.messages
        InputBox()
      end
    end
  end
```

Refresh the page and the error should be gone.

### Sending Messages

Next lets send some messages.  To do this the InputBox component will need to communicate when the user sends a new message.  We could add a callback like we did with the `Nav` component, but it might be more appropriate to use a different mechanism here.

We know we can send a message by doing a `@chat_service.send`, so if we just pass the `@chat_service` down to the InputBox we should be all set.  

So first update the `App` render method to pass the `@chat_service` to the InputBox:

```ruby
   ...
   InputBox chat_service: @chat_service
   ...
```

Now update the InputBox like this:

```ruby
class InputBox < React::Component::Base

  param :chat_service, type: ChatService

  before_mount { state.composition! "" }

  def render
    div do
      div {"Say Something: "}
      input(value: state.composition).on(:change) do |e|
        state.composition! e.target.value
      end.on(:key_down) do |e|
        send_message if is_send_key?(e)
      end
      FormattedDiv markdown: state.composition
    end
  end

  def is_send_key?(e)
    (e.char_code == 13 || e.key_code == 13)
  end

  def send_message
    params.chat_service.send(
      message: state.composition!(""),
      time: Time.now.to_i,
      from: params.chat_service.id
    )
  end

end
```

While we have done almost nothing new here, lets walk through so we are sure we understand everything.  

The `InputBox` receives a `ChatService` which it will use to get the current user id, and send each new chat message.

The `InputBox` has one state variable `state.composition` which just keeps track of the current message as the user types, just like we did with the `Nav` component.

Instead of a "send" button, we just wait till the user hits the Enter Key.

The current value of`state.composition` is passed along to the `FormattedDiv` which will (eventually) display the formatted markdown.

- #### Updating state variables returns the current value

    Unlike the assignment operator, when you update a state variable you get back the *current* value of the state.  Thus we can write `state.composition!("")` to clear the composition, while returning its current value.

### Formatting The Markdown

Lets get the `FormattedDiv` working.  The header loads the marked.js library which will convert markdown to html.  React will normally escape any raw html, but there is a special escape mechanism which we will use in our component.  

We will also use Opal-Ruby's native escape mechanism to insert raw javascript code so we can call the `marked` function.

Replace `FormattedDiv`'s `render` method with the following:

```ruby
def render
  div do
    div({dangerously_set_inner_HTML: { __html: `marked(#{params.markdown}, {sanitize: true})`}})
  end
end
```

Save your file, refresh, and login, and you should see the test messages as formatted html.

For more fun type some markdown into the input box and the formatted version will update as you type.

- #### Inserting raw HTML

    React makes this hard because its dangerous. The above syntax can be used whenever you need to directly insert some raw HTML.

- #### Opal Javascript Native

    In the above example we insert some raw javascript using the backquote literal.  Within the literal you can escape back out to Ruby using the `#{}` operator.  

Congratulations your chat app is basically working.  If you want change `test_chat_service.js` to `chat_service.js` and you can now run your client in several windows and watch things update nicely.

### Styling the App

We have a few more features to add, and if you have been observant you have noticed some bugs, but lets take a break and add some styling to our application.

We will use **Bootstrap** styles, which has already been included.  We just need a few additional styles so lets add those now to the inline style sheet at the top of your HTML file:

```css
  body {
    padding-top: 50px;
    padding-bottom: 60px;
  }
  div.alternating:nth-of-type(odd) {
    background-color: #ddd;
  }
  div.alternating:nth-of-type(even) {
    background-color: #ccc;
  }
  .input-box {
    padding: 10px;
  }
  .white {
    color: white;
  }
  .message {
    padding-top: 10px;
  }
  textarea {
    width: 100%;;
  }
  div.reactrb-icon {
    float: left;
    width: 50px;
    height: 50px;
    margin-right: 8px;
    background-size: contain;
    background-image: url("http://ruby-hyperloop.io/images/hyperloop_white.svg");
}
```

In Reactrb you can add classes to elements using css dot notation.

So instead of saying `div(class: "foo bar")` you can say `div.foo.bar`

Any dashes in class names should be translated to underscores.  For example:

`div.navbar.navbar_inverse.navbar_fixed_top` is the same as `div(class: "navbar navbar-inverse navbar-fixed-top")`

With this we are ready to beautify our `Nav` component.  Replace the render method with the following code.

```ruby
def render
  div.navbar.navbar_inverse.navbar_fixed_top do
    div.container do
      div.collapse.navbar_collapse(id: "navbar") do
        form.navbar_form.navbar_left(role: :search) do
          div.form_group do
            input.form_control(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
            ).on(:change) do |e|
              state.user_name_input! e.target.value
            end
            button.btn.btn_default(type: :button) { "login!" }.on(:click) do
              login!
            end if valid_new_input?
          end
        end
      end
    end
  end
end
```

While this looks complicated notice that in the middle is our original input tag.  We have just added wrappers around it, and added the `form_control` class to the input, and the `btn` and `btn-default` classes to the login button.

Refresh you browser and things should start looking better already.

Lets move on to the `Message` and `Messages` components.  First add the class `container` to the `Messages` div.  The `Messages` render method should now look like this:

```ruby
def render
  div.container do # add the bootstrap .container class here.
    params.messages.each do |message|
      Message message: message
    end
  end
end
```

Now add the `row, alternating` and `message` classes to the outer div of the Message component, and the `col-sm-2` class to the sender and time divs.  (Remember to change dashes to underscores.)

Now add the `class: "col-sm-8"` to the `FormattedDiv` element.  Notice that you can not use the short hand syntax with application defined components.  

Your `Message` render method should look like this:

```ruby
def render
  div.row.alternating.message do
    div.col_sm_2 { params.message[:from] }
    FormattedDiv class: "col-sm-8", markdown: params.message[:message]
    div.col_sm_2 { Time.at(params.message[:time]).to_s }
  end
end
```

Finally we need to update `FormattedDiv` so that it accepts all the normal html attributes uses them in the outer div.  This will allow us to specify different style classes for the `FormattedDiv` in the message display and in the input box.

The `collect_other_params_as` macro is used to gather up any params not specified in param declarations and save them in a hash.  This can then be passed along to children components (in our case the outer div) as their attributes.

Update the `FormattedDiv` `render` method so it looks like this:

```ruby
class FormattedDiv < React::Component::Base

  param :markdown, type: String
  collect_other_params_as :attributes

  def render
    div(params.attributes) do # send whatever class is specified on to the outer div
      div({dangerously_set_inner_HTML: { __html: `marked(#{params.markdown}, {sanitize: true })`}})
    end
  end
end
```

**Okay** refresh your browser, and login, and things should be looking pretty good.

Lets continue on, and update the `InputBox` component.

Add the `row, form-group, input-box, navbar, navbar-inverse, navbar-fixed-bottom` classes to the outer `div`.

Add the `col-sm-1` and `white` classes to the "Say Something" div.

Add the `col-sm-5` class to the `input`

Finally add `class: "col-sm-5 white"` to the `FormattedDiv` element.

Your updated render method should look like this:

```ruby
def render
  div.row.form_group.input_box.navbar.navbar_inverse.navbar_fixed_bottom do
    div.col_sm_1.white {"Say: "}
    input.col_sm_5(value: state.composition).on(:change) do |e|
      state.composition! e.target.value
    end.on(:key_down) do |e|
      send_message if is_send_key?(e)
    end
    FormattedDiv class: "col-sm-5 white", markdown: state.composition
  end
end
```

### Multiline Inputs

Now that our app looks better, we are motivated to clean up the remaining problems.  First off our `InputBox` only lets us enter single lines.  Lets fix that!

First change the `input` element to a `textarea` element which will allow us to display multiple lines.

Now go back and change the expression in the `is_send_key?`` method to also check for a ctrl or meta key.  

**Note:** You will need to press Ctrl-Enter to submit.

```ruby
def is_send_key?(e)
  (e.char_code == 13 || e.key_code == 13) && (e.meta_key || e.ctrl_key)
end
```

Try it out in your browser.  You should now be able to enter multiple line inputs.

Its still not quite perfect.  If you type more than two lines it gets hard to see our text.  We would like the text box to expand as more lines are typed up to some maximum.

All we need to do is add the `rows` attribute to the `textarea` and calculate the rows based on the current number of lines in the text area box.

Add this method right after the `render` method:

```ruby
def rows
  [state.composition.count("\n") + 1,20].min
end
```

and pass the value of our new `rows` method to the `rows` attribute of the `textarea`:

```ruby
  textarea.col_sm_5(rows: rows, value: state.composition)...
```

Refresh and you should be see the textarea dynamically grow as you type more text, and then collapse when you send a message.

This brings up a very important point about states:

+ Where possible compute values rather than adding state

+ You might be tempted to create a state variable called rows that is updated whenever the text area changes.  

+ This may (or may not) be slightly more effecient, but it introduces a lot of complexity.  

+ Instead where ever possible compute values from existing state.


### Automatic Scroll Position

You may have noticed that when you enter a message, you can't see it until you scroll down.  We would like to automatically scroll down when a message is sent so you can see it.  While we are at it, we will also make any new incoming messages do the same thing.

Displaying the messages is the responsibility of the `Messages` component so that is where this fix will go.

First add this method to the bottom of the `Messages` component:

```ruby
def scroll_to_bottom
  Element['html, body'].animate({scrollTop: Element[Document].height}, :slow)
end
```

Now all we need to do is call `scroll_to_bottom` whenever our message data changes.  What we need to do is hook into the `after_mount`, and `after_update` callbacks.  `after_mount` runs after the initial rendering of a component, and likewise `after_update` runs after every subsequent update.

Add these two lines right after the param declaration in the `Messages` component:

```ruby
after_mount :scroll_to_bottom
after_update :scroll_to_bottom
```

Notice that instead of providing a block to the callbacks we are providing the name of a method to call, which is handy in this case since we want to use the same method twice.

After making these changes you will see that after any update to the message display the window is scrolled to the bottom.

### Detecting the Logged In User

The display is a bit impersonal.  If I am logged in, then messages from me should say "You" instead of my login name.

Lets fix this.

Add this method to the bottom of the `Message` component:

```ruby
def sender
  if params.message[:from] == params.user_id
    "you: "
  else
    "#{params.message[:from]}:"
  end
end
```

and replace `params.message[:from]` in the `render` method with `sender`.

But we have to pass the `user_id` down from the App component (`@chat_service.id`) to `Messages`, and
from `Messages` to `Message`.  Once you have added the params and passed them along, refresh your browser.

If you are still using the test fixture then login as `user1` and see the results.

### Formatting The Time Stamp

While we are fixing the `Message` component lets clean up the time stamp column.  The time stamp is not only ugly, its also not informative.  Lets make it so it progressively changes formats the older the message gets.

Add this method to the bottom of the `Message` component:

```ruby
def formatted_time
  time = Time.at(params.message[:time])
  if Time.now < time+1.day
    time.strftime("%I:%M %p")
  elsif Time.now < time+7.days
    time.strftime("%A")
  else
    time.strftime("%D %I:%M %p")
  end
end
```

and then call `formatted_time` instead of just displaying the raw time.

### A Final Bug Fix

Try logging in, and then logging in again, either as the same or different user.  Notice that the list of messages is duplicated.

Our chat service supplies us with all existing messages when somebody logs in.  And our `App` component happily appends all the incoming messages.  

What we need to do is clear the messages during the login process.

Add this line at the beginning of the `App` login method:

```ruby
...
state.messages! nil
...
```

Make sure you do this before sending the credentials to the chat service.

### Final Touches

You may notice that you can't hit the enter key to login.  Instead the enter key refreshes the page.

To fix this the `Nav` component will need to two additional event handlers, one to track the `key_down` event, and the other to clear the `submit` event for the form.

Add this handler to the `input` element:

```ruby
on(:key_down) do |e|
  login! if valid_new_input? && e.key_code == 13
end
```

and add this handler to the `form`.

```ruby
on(:submit) { |e| e.prevent_default }
```

While we are in there lets add the Reactrb logo and a title to the nav bar.  Add

```ruby
div.navbar_header do
  div.reactrb_icon
  a.navbar_brand(href: "#", style: {color: "#00d8ff"}) { "Reactrb Chat Room " }
end
```

inside the `container` `div`.

Finally lets use one of the standard bootstrap login icons instead of the words "Login!".

Replace `{ "Login!" }` with `{ span.glyphicon.glyphicon_log_in }`

Now the completed `Nav` `render` method will look like this:

```ruby
def render
  div.navbar.navbar_inverse.navbar_fixed_top do
    div.container do
      div.navbar_header do
        div.reactrb_icon
        a.navbar_brand(href: "#", style: {color: "#00d8ff"}) { "Reactrb Chat Room " }
      end
      div.collapse.navbar_collapse(id: "navbar") do
        form.navbar_form.navbar_left(role: :search) do
          div.form_group do
            input.form_control(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
            ).on(:change) do |e|
              state.user_name_input! e.target.value
            end.on(:key_down) do |e|
              login! if valid_new_input? && e.key_code == 13
            end
            button.btn.btn_default(type: :button) { span.glyphicon.glyphicon_log_in }.on(:click) do
              login!
            end if valid_new_input?
          end
        end.on(:submit) { |e| e.prevent_default }
      end
    end
  end
end
```

Now that you are all done make sure you change from the test fixture so your app interacts with the webservice.

Update this line in the html header

```HTML
<script src="http://ruby-hyperloop.io/javascripts/test_chat_service.js"></script>
```

to read

```HTML
<script src="http://ruby-hyperloop.io/javascripts/chat_service.js"></script>
```

and you will be sending and receiving messages from the chat server.  Try opening your a second browser window to get the full experience.

**Congratulations**

You have built a very nice functional application.   We hope you have enjoyed the process.  Happy Coding!

#### Source code of the steps up until 'Detecting loged in user'

```ruby
<script type="text/ruby">
class App < React::Component::Base

  before_mount do
   @chat_service = ChatService.new do | messages |
     state.messages! ((state.messages || []) + messages)
     puts "state messages updated.  state.messages: #{state.messages}"
   end
  end

  def render
    div do
      Nav login: method(:login).to_proc
      if online?
        Messages messages: state.messages
        InputBox chat_service: @chat_service
      end
    end
  end

  def login(user_name)
    @chat_service.login(user_name)
  end

  def online?
    state.messages
  end
end

class Nav < React::Component::Base
  param :login, type: Proc

  before_mount do
    state.current_user_name! nil
    state.user_name_input! ""
  end

  def render
    div.navbar.navbar_inverse.navbar_fixed_top do
      div.container do
        div.collapse.navbar_collapse(id: "navbar") do
          form.navbar_form.navbar_left(role: :search) do
            div.form_group do
              input.form_control(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
              ).on(:change) do |e|
                state.user_name_input! e.target.value
              end
              button.btn.btn_default(type: :button) { "login!" }.on(:click) do
                login!
              end if valid_new_input?
            end
          end
        end
      end
    end
  end

  def valid_new_input?
    state.user_name_input.present? && state.user_name_input != state.current_user_name
  end

  def login!
     state.current_user_name! state.user_name_input
     params.login(state.user_name_input)
  end
end

class Messages < React::Component::Base
  param :messages, type: [Hash]

  def render
    div.container do # add the bootstrap .container class here.
      params.messages.each do |message|
        Message message: message
      end
    end
  end
end

class Message < React::Component::Base
  param :message, type: Hash

  after_mount :scroll_to_bottom
  after_update :scroll_to_bottom

  def render
   div.row.alternating.message do
     div.col_sm_2 { params.message[:from] }
     FormattedDiv class: "col-sm-8", markdown: params.message[:message]
     div.col_sm_2 { Time.at(params.message[:time]).to_s }
   end
  end

  def scroll_to_bottom
    Element['html, body'].animate({scrollTop: Element[Document].height}, :slow)
  end
end

class InputBox < React::Component::Base
  param :chat_service, type: ChatService

  before_mount { state.composition! "" }

  def render
    div.row.form_group.input_box.navbar.navbar_inverse.navbar_fixed_bottom do
      div.col_sm_1.white {"Say: "}
      textarea.col_sm_5(rows: rows, value: state.composition).on(:change) do |e|
        state.composition! e.target.value
      end.on(:key_down) do |e|
        send_message if is_send_key?(e)
      end
      FormattedDiv class: "col-sm-5 white", markdown: state.composition
    end
  end

  def rows
    [state.composition.count("\n") + 1,20].min
  end

  def is_send_key?(e)
    #(e.char_code == 13 || e.key_code == 13)
    (e.char_code == 13 || e.key_code == 13) && (e.meta_key || e.ctrl_key)
  end

  def send_message
    params.chat_service.send(
      message: state.composition!(""),
      time: Time.now.to_i,
      from: params.chat_service.id
    )
  end
end

class FormattedDiv < React::Component::Base
  param :markdown, type: String
  collect_other_params_as :attributes

  def render
    div(params.attributes) do # send whatever class is specified on to the outer div
      div({dangerously_set_inner_HTML: { __html: `marked(#{params.markdown}, {sanitize: true })`}})
    end
  end
end
</script>
```
