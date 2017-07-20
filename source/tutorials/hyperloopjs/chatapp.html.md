---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">C</span>hat-App Tutorial

We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.

![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-chatapp/master/hyperloopjschatappscreenshot.png)


You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-js-chatapp';">Hyperloop.js ChatApp Source code</button>

Our Chat app will provide:

* A login window to register your chat handle
* A view of the current chat conversation
* An input box to submit a chat

It will also have a few neat features:

* **Live updates:** other users' chats are popped into the conversation view in real time.
* **Dynamic Time Formatting:** the time format changes as that chat ages.
* **Markdown formatting:** users can use Markdown to format their text.
* **Uses Bootstrap:** for styling


### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop.js installation](/installation#hyperloopjssetup) tutorial.

##### Step 1 - Preparation

After following the installation tutorial, you should have a HTML file looking like this:

```html
<!-- hyperloopjs-chatapp.html -->

<!DOCTYPE html>
<html>
  <head>

    <meta charset="UTF-8" />
    <title>Hyperloop Chat App</title>

    <!-- React and JQuery -->
    <script src="https://unpkg.com/react@15/dist/react.min.js"></script>
    <script src="https://unpkg.com/react-dom@15/dist/react-dom.min.js"></script>
    <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>

    <!-- Opal and Hyperloop -->
    <script src="https://rawgit.com/ruby-hyperloop/hyperloop-js/master/opal-compiler.min.js"></script>
    <script src="https://rawgit.com/ruby-hyperloop/hyperloop-js/master/hyperloop.min.js"></script>
  </head>

  <body>

    <script type="text/ruby">

      class Helloworld < Hyperloop::Component
        def render
          DIV do
            "hello world !"
          end
        end
      end

    </script>


    <div data-hyperloop-mount="Helloworld"
       data-name="">
    </div>

  </body>


</html>

```

We are going to add 3 external libraires needed for our sample ChatApp (Bootstrap and markedown):

```html
<!-- hyperloopjs-chatapp.html -->

  <head>

    ...

    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/0.3.5/marked.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
    
  </head>

</html>
```

##### Step 2 - Application Structure

Hyperloop is all about modular, composable components. For our chat app, we'll have the following structure which will be mirrored by 6 corresponding Hyperloop components:

```
ChatApp
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

Each component will render the corresponding portion of the UI and is described by a Ruby class that inherits from Hyperloop::Component.

Let's stub out all of classes right now.  Replace the contents inside  the
`<script type="text/ruby">...</script>` tag with the following ruby code.

```ruby
class ChatApp < Hyperloop::Component
  def render
    DIV do
      Nav()
      Messages()
      InputBox()
    end
  end
end

class Nav < Hyperloop::Component
  def render
    DIV {"Our Nav Bar Goes Here including a login box"}
  end
end

class Messages < Hyperloop::Component
  def render
    # eventually we will loop and display each message
    # for now we will just display one as an example
    Message()
  end
end

class Message < Hyperloop::Component
  def render
    FormattedDiv()
  end
end

class InputBox < Hyperloop::Component
  def render
    DIV do
      "An input box to send new messages will".br
      "go here plus a display of the formatted markdown".br
      FormattedDiv()
    end
  end
end

class FormattedDiv < Hyperloop::Component
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

Before going on lets understand the basic features of the Hyperloop DSL

- ###### Every component has a `render` method

    Each component is a class that inherits from `Hyperloop::Component` and defines a `render` method.

- ###### The `render` method must generate a single `React::Element`  

    Look at the `ChatApp` component: it wraps its three *children* in a `div`.  If you forgot this wrapper `div` you would get this error in the browser's javascript console:

    ```
    RuntimeError: a components render method must generate and return exactly 1 element or a string
    ```

- ###### HTML tags are Ruby methods

    Within the `render` method each html tag has a corresponding Ruby method.  Each of these methods generates a single `React::Element`, which contains component type plus parameters, plus any nested elements.  

    All HTML tags have lower case names matching their HTML counter parts.

- ###### Application components also define Ruby methods

    You generate a `Message` component by calling the `Message()` method

    Because the component class and the component method share the same name you must include either (possibly empty) parenthesis, or block literal following the component name, so Ruby knows you mean to call a method.

    `Message  ` <- a class name
    `Message()` <- generate a `Message` element.

- ###### By default strings are wrapped by `SPAN` tags

    Now go all the way down to the `FormattedDiv` component.  If a string appears as the last expression (the returned value) of either a render method or a component's block, the string is wrapped in a `SPAN` as if you had typed `SPAN { "some string" }`.

- ###### Strings also respond to `BR, SPAN, PARA, TH` and `TD`

    Strings also respond to several element generating methods: `BR, SPAN, PARA` (for `P`), `TD` and `TH`.  Again this is just short hand, so `"foo".TD` is short for `TD { "foo" }`

##### Step 3 - Adding Parameters:

Components have parameters just like methods.  Now that we have the basic ChatApp structure, understanding a component's params is a good next step.  Lets start by adding the `markdown` parameter to the `FormattedDiv` component.

Update the `Message, InputBox` and `FormattedDiv` components so they look like this:

```ruby
class Message < Hyperloop::Component

  def render
    FormattedDiv(markdown: "This **Markdown** will eventually be a message")
  end
end

class InputBox < Hyperloop::Component
  def render
    DIV do
      "An input box to send new messages will".BR
      "go here plus a display of the formatted markdown".BR
      FormattedDiv(markdown: "This **Markdown** will get updated as the user types")
    end
  end
end

class FormattedDiv < Hyperloop::Component

  param :markdown, type: String

  def render
    DIV do
      params.markdown
    end
  end
end
```

- ###### The `param` *macro* describes the *inputs* to a component.

    In our case the `FormattedDiv` component will *receive* the `markdown` param from either the
    `Message` or `InputBox` components.  

- ###### Params can have an optional type.

    In our case we declare `markdown` to be a `String`.  If the incoming parameter does not match the type a warning will be displayed on the console.  While typing your params is optional its highly recommended.

- ###### Params are accessed using the `params` object.

    Each `param` you declare in a component will have a corresponding method on the `params` object.  Component parameters are accessible by any instance method within your component using the `params` object.  

##### Step 4 -  Adding An Event Handler:

Our application will need to respond to three types of events:

+ A user logs in
+ A user sends a chat
+ Receiving chat messages.

We will start by adding a basic user login handler.

We decided up front that the login box will be part of the top nav bar, so that is where we will add it:

```ruby
class Nav < Hyperloop::Component

  def render
    DIV do
      INPUT(class: :handle, type: :text, placeholder: "Enter Your Handle")
      BUTTON(type: :button) { "login!" }.on(:click) do
        alert("#{Element['input.handle'].value} logs in!")
      end
    end
  end

end
```

Replace the `Nav` component with the above code, and refresh your browser.  You should now be able to "login".

Things to notice:

- ###### Event handlers are attached to any element using the `on` method.

    The `on` method takes the event name and a block.  The block is called when the event occurs.

- ###### Tag attributes are passed just like params.

    `INPUT(class: :handle, type: :text, placeholder: "Enter Your Handle")`  
    generates  
    `<input class="handle", type="text", placeholder="Enter Your Handle" />`

- ###### Strings and Symbols are the same type in Opal.

    For effeciency the Opal-Ruby transpiler treats Ruby symbols as strings.  So  
    `:text == 'text'`

- ###### `Element` is the Opal-Ruby jQuery compatible wrapper.

    `Element['input.handle'].value` translates to `$('input.handle').value()`  
    Be aware that `React::Element` which we refer to as *elements* through out the tutorial is not the same as Opal's `Element` wrapper.

##### Step 5 - Adding State:

Our improved `Nav` component is still pretty dull, and having to directly access the DOM using `Element` is not a great idea either.

To add some intelligence to our `Nav` component it needs *state*.  Hyperloop provides *state variables* that work like *reactive* instance variables.  When a state variable is updated, it will cause components to re-render.  

We are going to add two state variables to our component:  `current_user_name` and `user_name_input`.  

`current_user_name` is either `nil` (meaning there is no valid user name) or contains the user name string.

`user_name_input` will track the user name as it is typed allowing us to dynamically update the UI based on what the user has typed.

```ruby
class Nav < Hyperloop::Component

  before_mount do
    mutate.current_user_name! nil
    mutate.user_name_input! ""
  end

  def render
    DIV do
      INPUT(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
      ).on(:change) do |e|
        mutate.user_name_input e.target.value
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
    mutate.current_user_name state.user_name_input
    puts "*** #{state.current_user_name} has logged in"
  end

end
```

Once again, update the `Nav` component, and make sure it works.  

Things to notice:

- ###### State variables are read through the `state` object.

    Each state variable has a read accessor on the state object:
    `state.user_name_input`

- ###### State variables are written through the `mutate` object.

    The method `mutate` will update state and cause re-rendering of the component.

- ###### There is no *assignment* method for state variables.

    There are several reasons for this, that we will discuss later, but for now you can
    consider the write accessor (or `mutate` method) to be equivalent to assignment.

- ###### Initialize state in the `before_mount` callback.

    The `before_mount` *lifecycle* callback is called after `params` are first initialized, but before
    render is called, so its the place to initialize your state variables.

    More on the *lifecycle* callbacks later.

- ###### Event handlers are passed the event object

    As each character is typed we use the event object to update `state.user_name_input`.  

    Besides giving us dynamic access to the state of the user input as its changing, `state.user_name_input` also frees us from having to tag and interrogate DOM objects directly.

- ###### As state changes, the component will rerender.

    For example the login button is only rendered if there is valid new input.

    In React you think declaratively about the UI.  At any point in time the
    `render` method simply draws the UI based on params and the current state of the
    component.  As the component state changes, or when it receives new params, `render`
    is called to deliver the updated UI.

    Under the hood React.js has efficient algorithms to insure that the minimum DOM
    update is performed.

- ###### Use helper methods to keep `render` simple.

    For example we created the `is_valid_new_input?` method, and moved the login logic to the `login!` method.

    This helps to understand the core logic and layout of the `render` method.

- ###### The `puts` method logs on the js debug console

##### Step 6 - Talking to Your Parents

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
    mutate.current_user_name state.user_name_input
    params.login(state.user_name_input)
  end
```

Again reload your browser and try logging in.  You will notice in the console that there is a new warning:

```console
Warning: Failed propType: In component `Nav`
Required prop `login` was not specified Check the render method of `ChatApp`.
```

Which makes sense, as we specified that `Nav` wants a `login` parameter, but `App` did not provide one.  

Lets go ahead and add the callback to the `ChatApp` component.  Add the following method to the bottom of the `ChatApp`:

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

- ###### Callbacks are a simple way to communicate upwards

    As we will see there are other mechanisms which are often more appropriate but in this case a call back `Proc` is the perfect solution.  

    To implement a callback you declare the param type as `Proc`.  This tells the `params` object to treat the param as a method call, rather than just returning its value.  

    Meanwhile in the parent component you will need to pass a `Proc` to the component.  Ruby lets you create and access `Proc`s in several ways, in our case we converted the instance method `login` to a `Proc` using `method`.

- ###### React takes the approach of warning vs. errors when things go wrong

    The good thing is this allows you some wiggle room as you are building and testing your components.

    The downside is that you need to keep an eye on the console log, and find and remove unexpected warnings.

Before we go on note that this is an example application.  In a real world app we would probably
not use this mechanism for logging on.  A real login component would need to check credentials and would
have additional state to track and report the progress of the login process.

##### Step 7 - The Chat Service

For this tutorial purpose we are going, for now, implement a **Chat service** emulation, all written in Opal. So you just have to include this code into the HTMl page we are working on: 

```ruby
<script type="text/ruby">

class ChatService

  def initialize(&block)
    @block = block
    @messages = {"from"=>"user1", "time"=>1449089985, "message"=>"A 2 point message: \n+ point 1\n+ point 2\nGot it?"},{"from"=>"user2", "time"=>1449262785, "message"=>"message sent 8 days ago, by user 2"},{"from"=>"user3", "time"=>1449521985, "message"=>"message sent in the last week"},{"from"=>"user2", "time"=>1449608385, "message"=>"message sent **also** in the last week"},{"from"=>"user1", "time"=>1449950385, "message"=>"Was sent within the last hour!"},{"from"=>"user2", "time"=>1449952185, "message"=>"Was sent 30 minutes ago"},{"from"=>"user3", "time"=>1449953385, "message"=>"Was just sent\n\n\n\n\n\n\n\n\nwith a lot of blanks"},{"from"=>"user1", "time"=>1449953985, "message"=>"just now"}
  end

  def login(user_name)
    @user_name = user_name
    @block.call @messages
  end

  def id
    @user_name
  end

  def send(data = {})
    @messages << data
    @block.call [data]
  end

end

</script>
```

As you can see, we have now 2 usefull method: `login` and `send`. And the hash `messages` is initialized with sample data.

Armed with this, we are ready to start displaying chat messages.

##### Step 8 - Lifecycle Callbacks

A react component has a well defined life cycle, and your components can hook into the lifecycle using the callback macros.  In our application we will use three of the most common callbacks `before_mount, after_mount` and `after_update`.  

Each call back takes a block or the name of a method, which will be called as the component passes through each stage in its lifecycle.

When our App starts (**mounts** in React terms) we need to initialize the chat service.

Add this code to the beginning of the `ChatApp` component:

```ruby
  before_mount do
    ChatService.new do | messages |
      if state.messages
        mutate.messages state.messages + messages
      else
        mutate.messages messages
      end
      puts "state messages updated.  state.messages: #{state.messages}"
    end
  end
```

Before the component mounts our callback will execute and it creates a new `ChatService` instance.  

As each new set of messages arrives the block will execute which will initialize or append the messages to the `state.messages` state variable.  We know we want to make this a state variable since it clearly is going to change asynchronously overtime, and we will want to update the UI when that occurs.

Refresh your browser, and make sure nothing is broken, but notice nothing is changing.  *Why Not?* - because we have not logged in yet.

##### Step 9 - Instance and State Variables

Okay so while we can initialize the chat service when `ChatApp` mounts, nothing will happen until the user logs in.  

We have our login method already defined, so we just want to change it so that it passes the login to the chat service.  To do this we have to save the chat service object in the `before_mount` callback so that we can use it in the `login` method.

Change the `before_mount` callback to be:

```ruby
  before_mount do
    @chat_service = ChatService.new do | messages |
      mutate.messages ((state.messages || []) + messages)
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

- ###### Not everything has to be a state variable

    `@chat_service` is an instance variable, while `state.messages` is a state variable.

    We can see that as time passes new messages will come in, and we will want to re-render when this happens.  This led us to define `messages` as a state variable.  Because `messages` is a state variable as it changes re-rendering of the ChatApp component will automatically occur.

    But so far we have no reason to make `@chat_service` into a state variable, so we use a plain old instance variable.

    For our simple component the messages themselves are the only state we care about.

    We will come back to this discussion as we flesh out the rest of our application.

Now that we are logging in, connecting to the (test) chat service and updating our `messages` state variable, we are ready to display those messages.

Hopefully by this time you've got a rough idea how we are going to do this!

First update the `ChatApp` render method like this:

```ruby
  def render
    DIV do
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
    DIV do
      params.messages.each do |message|
        Message message: message
      end
    end
  end
```

Likewise the `Message` component needs to receive and display a message.  Replace the whole component with the following:

```ruby
class Message < Hyperloop::Component

  param :message, type: Hash

  def render
    DIV do
      DIV { params.message[:from] }
      FormattedDiv markdown: params.message[:message]
      DIV { Time.at(params.message[:time]).to_s }
    end
  end
end
```

Save everything, and refresh your browser.  Login and you should see a very rough but functional display of your messages!

- ###### Array type params

    Notice how we declared the `messages` param as type `[Hash]` this notation means "Array of Hash".

    You can also say `type: []` which means array of anything and is shorthand for `type: Array`.

##### Step 9 - Some Cleanup

Take a look at the console log, and you will see a big red error like this:

`Exception raised while rendering #<Messages:0x16fa>`  
`    NoMethodError: undefined method 'each' for nil`

Lets think about this.  When we first render `Messages`, there are no messages, so trying to send `each` to `nil` fails.

One nice thing about React is that it is very robust.  Even though we had this error, things still work.  Once we are logged in, we do have messages, and everything worked.

Anyway we need to fix this!  Add the following method to the bottom of the `ChatApp` class:

```ruby
  def online?
    state.messages
  end
```

For our simple App we are going to figure that we are logged in **if** `state.messages` is not `nil`.  

Now update the `ChatApp`s `render` method so that we don't display the `Messages` or the `InputBox` unless we are logged in.

```ruby
  def render
    DIV do
      Nav login: method(:login).to_proc
      if online?
        Messages messages: state.messages
        InputBox()
      end
    end
  end
```

Refresh the page and the error should be gone.

##### Step 10 - Sending Messages

Next lets send some messages.  To do this the InputBox component will need to communicate when the user sends a new message.  We could add a callback like we did with the `Nav` component, but it might be more appropriate to use a different mechanism here.

We know we can send a message by doing a `@chat_service.send`, so if we just pass the `@chat_service` down to the InputBox we should be all set.  

So first update the `ChatApp` render method to pass the `@chat_service` to the InputBox:

```ruby
   ...
   InputBox chat_service: @chat_service
   ...
```

Now update the InputBox like this:

```ruby
class InputBox < Hyperloop::Component

  param :chat_service, type: ChatService

  before_mount { mutate.composition "" }

  def render
    DIV do
      DIV {"Say Something: "}
      INPUT(value: state.composition).on(:change) do |e|
        mutate.composition e.target.value
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
      message: mutate.composition(""),
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

- ###### Updating state variables returns the current value

    Unlike the assignment operator, when you update a state variable you get back the *current* value of the state.  Thus we can write `mutate.composition("")` to clear the composition, while returning its current value.

##### Step 11 - Formatting The Markdown

Lets get the `FormattedDiv` working.  The header loads the marked.js library which will convert markdown to html.  React will normally escape any raw html, but there is a special escape mechanism which we will use in our component.  

We will also use Opal-Ruby's native escape mechanism to insert raw javascript code so we can call the `marked` function.

Replace `FormattedDiv`'s `render` method with the following:

```ruby
def render
  DIV do
    DIV({dangerously_set_inner_HTML: { __html: `marked(#{params.markdown}, {sanitize: true})`}})
  end
end
```

Save your file, refresh, and login, and you should see the test messages as formatted html.

For more fun type some markdown into the input box and the formatted version will update as you type.

- ###### Inserting raw HTML

    React makes this hard because its dangerous. The above syntax can be used whenever you need to directly insert some raw HTML.

- ###### Opal Javascript Native

    In the above example we insert some raw javascript using the backquote literal.  Within the literal you can escape back out to Ruby using the `#{}` operator.  

Congratulations your chat app is basically working.  

##### Step 12 - Styling the App

We have a few more features to add, and if you have been observant you have noticed some bugs, but lets take a break and add some styling to our application.

We will use **Bootstrap** styles, which has already been included.  We just need a few additional styles so lets add those now to the inline style sheet at the top of your HTML file:

```css
  body {
    padding-top: 100px;
    padding-bottom: 100px;
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
  .saytext {
    color: white;
    font-size: 2em;
    margin-left: 2em;
  }
  .message {
    padding-top: 10px;
    margin-top: 10px;
  }
  textarea {
    width: 100%;
    padding-top: 1em;
  }
  div.hyperloop-icon {
    float: left;
    width: 50px;
    height: 50px;
    margin-right: 8px;
    background-size: contain;
    background-image: url("hyperloop-logo-small-white.png");
      background-repeat: no-repeat;
  }
  .navbar-inverse {
    background-color: #149c8e;
    background-image: none;
    border-color: #e81176;
  }
  div.navbar {
    padding-top: 1.5em;
    padding-bottom: 2em;
  }
  .navbar-brand {
    font-size: 2.5em;
    font-weight: normal;
  }
```

With this we are ready to beautify our `Nav` component.  Replace the render method with the following code.

```ruby
def render
  DIV(class: 'navbar-fixed-top navbar-inverse navbar') do
    DIV(class: 'container') do
      DIV(class: 'navbar-collapse collapse', id: 'navbar') do
        FORM(class: 'navbar-left navbar-form', role: :search) do
          DIV(class: 'form-group') do
            INPUT(class: 'form-control', type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
                    ).on(:change) do |e|
              mutate.user_name_input e.target.value
            end
            BUTTON(class: 'btn-default btn', type: :button) { "login!" }.on(:click) do
              login!
            end if valid_new_input?
          end
        end
      end
    end
  end
end
```

While this looks complicated notice that in the middle is our original input tag.  We have just added wrappers around it, and added the `form-control` class to the INPUT, and the `btn` and `btn-default` classes to the login button.

Refresh you browser and things should start looking better already.

Lets move on to the `Message` and `Messages` components.  First add the class `container` to the `Messages` div.  The `Messages` render method should now look like this:

```ruby
def render
  DIV(class: 'container') do # add the bootstrap .container class here.
    params.messages.each do |message|
      Message message: message
    end
  end
end
```

Now add the `row, alternating` and `message` classes to the outer div of the Message component, and the `col-sm-2` class to the sender and time divs. 

Now add the `class: "col-sm-8"` to the `FormattedDiv` element.  Notice that you can not use the short hand syntax with application defined components.  

Your `Message` render method should look like this:

```ruby
def render
  DIV(class: 'row alternating message') do
    DIV(class: 'col-sm-2') { params.message[:from] }
    FormattedDiv class: "col-sm-8", markdown: params.message[:message]
    DIV(class: 'col-sm-2') { Time.at(params.message[:time]).to_s }
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
    DIV(params.attributes) do # send whatever class is specified on to the outer div
      DIV({dangerously_set_inner_HTML: { __html: `marked(#{params.markdown}, {sanitize: true })`}})
    end
  end
end
```

**Okay** refresh your browser, and login, and things should be looking pretty good.

Lets continue on, and update the `InputBox` component.

Add the `row, form-group, input-box, navbar, navbar-inverse, navbar-fixed-bottom` classes to the outer `div`.

Add the `col-sm-1` and `saytext` classes to the "Say Something" div.

Add the `col-sm-5` class to the `input`

Finally add `class: "col-sm-5 saytext"` to the `FormattedDiv` element.

Your updated render method should look like this:

```ruby
def render
  DIV(class: 'row form-group input-box navbar navbar-inverse navbar-fixed-bottom') do
    DIV(class: 'col-sm-1 saytext') {"Say: "}
    INPUT(class: 'col-sm-5', value: state.composition).on(:change) do |e|
      state.composition! e.target.value
    end.on(:key_down) do |e|
      send_message if is_send_key?(e)
    end
    FormattedDiv class: "col-sm-5 white", markdown: state.composition
  end
end
```

##### Step 13 - Multiline Inputs

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
  TEXTAREA(class: 'col-sm-5', rows: rows, value: state.composition)...
```

Refresh and you should be see the textarea dynamically grow as you type more text, and then collapse when you send a message.

This brings up a very important point about states:

+ Where possible compute values rather than adding state

+ You might be tempted to create a state variable called rows that is updated whenever the text area changes.  

+ This may (or may not) be slightly more effecient, but it introduces a lot of complexity.  

+ Instead where ever possible compute values from existing state.


##### Step 14 - Automatic Scroll Position

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

##### Step 15 - Detecting the Logged In User

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

```ruby
def render
  DIV(class: 'row alternating message') do
    DIV(class: 'col-sm-2') { sender }
    FormattedDiv class: "col-sm-8", markdown: params.message[:message]
    DIV(class: 'col-sm-2') { formatted_time }
  end
end
```

But we have to pass the `user_id` down from the ChatApp component (`@chat_service.id`) to `Messages`, and
from `Messages` to `Message`.  Once you have added the params and passed them along, refresh your browser.

```ruby
class Messages < Hyperloop::Component
  param :messages, type: [Hash]
  param :user_id

  def render
    DIV(class: 'container') do # add the bootstrap .container class here.
      params.messages.each do |message|
        Message message: message, user_id: params.user_id
      end
    end
  end

end
```

```ruby
class Message < Hyperloop::Component
  param :message, type: Hash
  param :user_id

  after_mount :scroll_to_bottom
  after_update :scroll_to_bottom

  def render
    DIV(class: 'row alternating message') do
      DIV(class: 'col-sm-2') { sender }
      FormattedDiv class: "col-sm-8", markdown: params.message[:message]
      DIV(class: 'col-sm-2') { formatted_time }
    end
  end

  def scroll_to_bottom
    Element['html, body'].animate({scrollTop: Element[Document].height}, :slow)
  end

  def sender
    if params.message[:from] == params.user_id
      "you: "
    else
      "#{params.message[:from]}:"
    end
  end

end
```

If you are still using the test fixture then login as `user1` and see the results.

##### Step 16 - Formatting The Time Stamp

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

##### Step 17 - A Final Bug Fix

Try logging in, and then logging in again, either as the same or different user.  Notice that the list of messages is duplicated.

Our chat service supplies us with all existing messages when somebody logs in.  And our `ChatApp` component happily appends all the incoming messages.  

What we need to do is clear the messages during the login process.

Add this line at the beginning of the `ChatApp` login method:

```ruby
...
mutate.messages nil
...
```

Make sure you do this before sending the credentials to the chat service.

##### Step 18 - Final Touches

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

While we are in there lets add the Hyperloop logo and a title to the nav bar.  Add

```ruby
DIV(class: 'navbar-header') do
  DIV(class: 'hyperloop-icon')
  A(href: "#", style: {color: "white"}, class: 'navbar-brand') { "Hyperloop Chat Room " }
end
```

inside the `container` `div`.

Finally lets use one of the standard bootstrap login icons instead of the words "Login!".

Replace `{ "Login!" }` with `{ SPAN(class: 'glyphicon glyphicon-log-in') }`

Now the completed `Nav` `render` method will look like this:

```ruby
def render
  DIV(class: 'navbar-fixed-top navbar-inverse navbar') do
    DIV(class: 'container') do
      DIV(class: 'navbar-header') do
        DIV(class: 'hyperloop-icon')
        A(href: "#", style: {color: "white"}, class: 'navbar-brand') { "Hyperloop Chat Room " }
      end
      DIV(class: 'navbar-collapse collapse', id: 'navbar') do
        FORM(class: 'navbar-left navbar-form', role: :search) do
          DIV(class: 'form-group') do
            INPUT(class: 'form-control', type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
            ).on(:change) do |e|
              state.user_name_input! e.target.value
            end.on(:key_down) do |e|
              login! if valid_new_input? && e.key_code == 13
            end
            BUTTON(class: 'btn-default btn', type: :button) { SPAN(class: 'glyphicon glyphicon-log-in') }.on(:click) do
              login!
            end if valid_new_input?
          end
        end.on(:submit) { |e| e.prevent_default }
      end
    end
  end
end
```


**Congratulations**

You have built a very nice functional application.   We hope you have enjoyed the process.  Happy Coding!


You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-js-chatapp';">Hyperloop.js ChatApp Source code</button>


<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>