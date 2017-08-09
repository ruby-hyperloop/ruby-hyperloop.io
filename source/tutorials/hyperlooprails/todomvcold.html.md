---
title: Tutorials, Videos, & Quickstarts
---
## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">T</span>odo MVC Tutorials

The tutorial below implements the classic Todo MVC tutorial using Hyperloop Components. The first thing we'll need to do is set up the Hyperloop environment. For this tutorial we'll be working of of Cloud9. The set-up instructions for this follows below, but you do not have to use Cloud9 if you so choose. You can follow the other set-up tutorials on this site as well.

### Chapter 1: Setting Things Up

Running Hyperloop in Cloud9

This is probably the easiest way to get started doing full stack development with Hyperloop if you don't already have Rails setup on your machine.

Even if you are an experienced Rails developer there are some advantages to doing your first experiments on cloud 9:

You will get a consistent setup, which will avoid any possible configuration problems between linux/mac/windows OS versions, etc.
Cloud9 supports co-development, so if you hit a snag it makes it even easier to get help from others.
Your development server can be accessed by others through your unique cloud9 url so you can immediately show people on other machines the Hyperloop multi-client synchronization.
Once you are comfortable with Hyperloop, transitioning your app back to your normal development environment is as easy as doing a git pull of your saved repo.

**Step 1: Get a Cloud9 account**

Go to cloud 9's [website](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi-1o7vpqnUAhVFwiYKHa_IAZYQFggmMAA&url=https%3A%2F%2Fc9.io%2F&usg=AFQjCNHeXGx8w99yPGVSzgrH-Wa2kB_mQw&sig2=fBVKBbZ90G8VhrFRJQc70g)


and signup for an account (you can use your github account for signup.) You will have to supply a credit card, but to our knowledge Cloud9 can be trusted!

make sure to Connect your Cloud9 account to your github account by going to settings (upper right corner) and clicking the connected services tab, click the connect button next to github and allow it access

**Step 2: Create Your New Workspace**

You will be invited to create your first workspace. Cloud9 gives you one private workspace and any number of public workspaces. We recommend you use the public option for your first experiments.

Put `git@github.com:ruby-hyperloop/rails-clone-and-go.git` into the field titled titled Clone from Git or Mercurial URL (optional).

Select the "Ruby on Rails" template type, and

Create Your Workspace!

**Step 3: Run the Setup Script**

Once your workspace is created you should see the readme displayed. Just follow the directions and run

`bin/setup` to complete the initialization process.

**Step 4: Fire Up The Server**

run `bin/hyperloop` or use the cloud9 run command (along the nav top bar)

**Step 5: Visit the App**

You can see the App running right in the IDE window by clicking on preview in the top nav bar, or by pasting your unique cloud9 url into another browser window. If you've used the clone from github, you should see a display of the current time

Be advised that load times may very according to your machine. The program is not broken if load times get longer.

To see if you have setup correctly, naviagate to /app/hyperloop/components/app.rb. In this file, you should see some code printing out to the screen. Try changing the string that is being printed and save then refresh you're preview to see if it changes in the preview!

WARNING STOP FOLLOWING OTHER INSTRUCTIONS WHEN YOU GET TO THE BOLDED PHRASE, "HYPERLOOP QUICK START"

### Chapter 2:  Hyperloop Models are Rails Models

We are going to add our Todo Model, and discover that Hyperloop models are in fact Rails models.
+ You can access the your rails models on the client using the same syntax you use on the server.
+ Changes on the client are mirrored on the server.
+ Changes to models on the server are synchronized with all participating browsers.
+ Data access is is protected by a robust *policy* mechanism.

Okay lets see it in action:

1. **Add the Todo Model:**  
In a new terminal window (click on circular green plus sign about current terminals) run:   
`bundle exec rails g model Todo title:string completed:boolean priority:integer`   
**VERY IMPORTANT!** Now look in the db/migrate/ directory, and edit the migration file you have just created. It should be titled with a long string of numbers then "create_todos" at the end. Change the line creating the completed boolean field so that it looks like this:    
```ruby
...
      t.boolean :completed, null: false, default: false
...
```
For details on 'why' see [this blog post.](https://robots.thoughtbot.com/avoid-the-threestate-boolean-problem)  Basically this keeps completed as a true boolean, and will avoid having to check between `false` and `nil` later on.  

Now run `bundle exec rails db:migrate`

+ **Make your Model Public:**    
*Move* `todo.rb` **and** `application_record.rb` from `app/models/` to `app/hyperloop/models`.  
This will make the model accessible on the clients, subject to any data access policies.  
*Note: The hyperloop installer adds a policy that gives full permission to all clients but only in development and test modes.  Have a look at `app/policies/application_policy` if you are interested.*
+ **Try It**    
* Change your `App` component's render method to
```ruby
class App < Hyperloop::Component
    render(DIV) do
        "Number of Todos: #{Todo.count}"
      end
    end
end
```
Reload the page you will see *Number of Todos: 0* displayed.
*Note: If this does not work, try adding the line `require_relative ‘application_record'` to the top of todo.rb*

<br>
Now in another terminal window start a rails console (enter `rails c` into terminal) and type:  
Todo.create(title: 'my first todo')  
and you will see the count change to 1!
<br>  
Now in a window type:  
Todo.create(title: 'my second todo')
and you will see the count change to 2!
<br>  
Go back to your rails console and type:
Todo.last.title  
and you will get back "my second todo"
<br>
Are we having fun yet?  I hope so!  As you can see Hyperloop is synchronizing the Todo model between the client and server.  As the state of the database changes HyperReact buzzes around updating whatever parts of the DOM were dependent on that data (in this case the count of Todos).


### Chapter 3: Creating the Top Level App Structure

Now that we have all of our pieces in place, lets build our application.

Replace the entire contents of `app.rb` with:

```ruby

# app/hyperloop/components/show.rb
class App < Hyperloop::Component
  render(DIV) do
    Header()
    Index()
    Footer()
  end
end

```

and the stub out the three sub components by adding three new ruby files to the app/hyperloop/components folder:

```ruby

# app/hyperloop/components/header.rb
class Header < Hyperloop::Component
  render(DIV) do
    "Header will go here"
  end
end

```

```ruby

# app/hyperloop/components/index.rb
class Index < Hyperloop::Component
  render(DIV) do
    "list of Todos will go here"
  end
end

```

```ruby

# app/hyperloop/components/footer.rb
class Footer < Hyperloop::Component
  render(DIV) do
    "Footer will go here"
  end
end

```
Once you add the Footer component you should see:

Header will go here  
list of Todos will go here  
Footer will go here  

### Chapter 4: Listing the Todos, HyperReact Params, and Prerendering

To display each Todo we will create a TodoItem component that takes a parameter:

```ruby

# app/hyperloop/components/todo_item.rb
class TodoItem < Hyperloop::Component
  param :todo
  render(LI) do
    params.todo.title
  end
end

```

We can use this component in our Index component:

```ruby

# app/hyperloop/components/index.rb
class Index < Hyperloop::Component
  render(UL) do
    Todo.each do |todo|
      TodoItem(todo: todo)
    end
  end
end

```
Now you will see something like
<div style="border:solid; margin-left: 10px; padding: 10px">
  <div>Header will go here</div>
  <ul>
    <li>my first todo</li>
    <li>my second todo</li>
  </ul>
  <div>Footer will go here</div>
</div>

<br>


As you can see components can take parameters (or props in react.js terminology.)

Params are declared using the `param` macro and are accessed via the `params` object.
In our case we *mount* a new TodoItem with each Todo record and pass the Todo as the parameter.   

Now open a rails or hyper-loop console and type `Todo.last.update(title: 'updated todo')` and you will see the last Todo in the list changing.

Try adding another Todo using `create` like you did before.

As you can see as the Model state changes Hyperloop keeps everything synchronized.

This is good time to talk about *prerendering*.  Prerendering (or server side rendering) means that the initial state of the browser window is computed server side and delivered to the browser with no javascript execution.  This is great for your initial page load times, and SEO.  You can think of HyperReact as a templating language that uses Ruby instead of ERB or HAML.  To prove this to yourself, try turning off javascript and reloading the page.  *To turn off javascript in the Chrome Developer Tools see this [Stack Overflow Question](http://stackoverflow.com/questions/13405383/how-to-disable-javascript-in-chrome-developer-tools)*

You will see that the page loads fine, but of course it can no longer react to external changes in state.

Make sure you turn javascript back on before proceeding.

### Chapter 5: Adding Inputs to Components

So far we have seen how our components are synchronized to the data that they display.  Next let's add the ability for the component to *change* the underlying data.

First add an `INPUT` html tag to your TodoItem component like this:

```ruby

# app/hyperloop/components/todo_item.rb
class TodoItem < Hyperloop::Component
  param :todo
  render(LI) do
    INPUT(type: :checkbox, checked: params.todo.completed)
    params.todo.title
  end
end

```
Now your display should look like this:
<div style="border:solid; margin-left: 10px; padding: 10px">
  <div>Header will go here</div>
  <ul>
    <li>
      <input type="checkbox" value="on">
      my first todo
    </li>
    <li>
      <input type="checkbox" value="on">
      my second todo
    </li>
  </ul>
  <div>Footer will go here</div>
</div>
<br>
You will notice that while it does display the checkboxes, you can not change them by clicking on them.

You can of course change them via the console (or the hyper-console).  Try  
`Todo.last.update(completed: true)`  
and you should see the last Todo's `completed` checkbox changing state.

To make our checkbox input change its own state, we will add an `event handler` for the click event:

```ruby

# app/hyperloop/components/todo_item.rb
class TodoItem < Hyperloop::Component
  param :todo
  render(LI) do
    INPUT(type: :checkbox, checked: params.todo.completed)
    .on(:click) { params.todo.update(completed: !params.todo.completed) }
    params.todo.title
  end
end

```
It reads like a good novel doesn't it?  On a `click` event update the todo, setting the completed attribute to the opposite of its current value.

Meanwhile HyperReact sees the value of `params.todo.checked` changing, and this causes the associated HTML INPUT tag to be re-rendered.

We will finish up by adding a delete link at the end of the Todo item:

```ruby

# app/hyperloop/components/todo_item.rb
class TodoItem < Hyperloop::Component
  param :todo
  render(LI) do
    INPUT(type: :checkbox, checked: params.todo.completed)
    .on(:click) { params.todo.update(completed: !params.todo.completed) }
    SPAN { params.todo.title } # See note below...
    A { ' -X-' }.on(:click) { params.todo.destroy }
  end
end

```
*Note: If a component or tag block returns a string it is automatically wrapped in a SPAN, to insert a string in the middle you have to wrap it a SPAN like we did above.*

I hope you are starting to see a pattern here.  HyperReact components determine what to display based on the `state` of some objects.  External events, such as mouse clicks, the arrival of new data from the server, and even timers, update the `state`.  HyperReact recomputes whatever portion of the display depends on the `state` so that the display is always in sync with the `state`.  In our case the objects are the Todo model and its associated records, which has a number of associated internal `states`.  

By the way, you don't have to use models to have states.  We will see later that states can be as simple as boolean instance variables.

### Chapter 6: Routing

Now that Todos can be *completed* or *active*, we would like our user to be able display either "all" Todos, only "completed" Todos, or "active" (or incomplete) Todos.  We want our URL to reflect which filter is currently being displayed.  So `/all` will display all todos, `/completed` will display the completed Todos, and of course `/active` will display only active (or incomplete) Todos.

To achieve this we first need to be able to *scope* (or filter) the Todo Model. So let's edit the Todo model file so it looks like this:

```ruby

# app/hyperloop/models/todo.rb
class Todo < ApplicationRecord
  scope :completed, -> () { where(completed: true)  }
  scope :active,    -> () { where(completed: false) }
end

```

Now we can say `Todo.all`, `Todo.completed`, and `Todo.active`, and get the desired subset of Todos.  You might want to try it now in the hyper-console or the rails console.  *Note: if you use the rails console you will have to do a `reload!` to load the changes to the model.*

Having the application display different data (or whole different components) based on the URL is called routing.  Rails also has routing, but in our case we are letting our Hyperloop application take care of routing, so the first step is to tell rails to simply accept any url as valid, and pass it to our `App` component.  

So the next step is have our top level `App` component *route* the URL, and the `Index` component react to changes in the URL.  Change `App` to look like this:

```ruby

# app/hyperloop/components/show.rb
class App < Hyperloop::Router
  history :browser
  route do
    DIV do
      Header()
      Route('/:scope', mounts: Index)
      Footer()
    end
  end
end

```

and the `Index` component to look like this:

```ruby

# app/hyperloop/components/index.rb
class Index < Hyperloop::Router::Component
  render(UL) do
    Todo.send(match.params[:scope]).each do |todo|
      TodoItem(todo: todo)
    end
  end
end

```
Note that because we have changed the class of these components the hot reloader will break, and you will have to refresh the page.

Lets walk through the changes:
+ `App` now inherits from `Hyperloop::Router` which is a subclass of `Hyperloop::Component` with *router* capabilities added.
+ The `history` macro tells the router how to track the history (back/forward buttons).  
The `:browser` history tracks the history invisibly in the html5 browser history.
The other common option is the `:hash` history which tracks the history in the url hash.
+ The `render` macro is replaced by `route`, and the `DIV` tag is moved inside the route block.
+ Instead of directly mounting the `Index` component, we *route* to it based on the URL.  In this case if the url must look like `/xxx`.   
Later we will also add the ability to match the root ('/') URL as well.
+ `Index` now inherits from `Hyperloop::Router::Component` which is a subclass of `Hyperloop::Component` with methods like `match` added.
+ Instead of simply enumerating all the Todos, we decide which *scope* to filter using the URL fragment *matched* by `:scope`.  

Notice the relationship between `Route('/:scope', mounts: Index)` and `match.params[:scope]`:  
During routing each `Route` is checked.  If it *matches* then the
indicated component is mounted, and the match parameters are saved for that component to use.

You should now be able to change the url from `/all`, to `/completed`, to `/active`, and see a different set of Todos.  For example if you are displaying the `/active` Todos, you will only see the Todos that are not complete.  If you check one of these it will disappear from the list.

### Chapter 7:  Helper Methods, Inline Styling, Active Support and Router Nav Links

Of course we will want to add navigation to move between these routes.  We will put the navigation in the footer:

```ruby

# app/hyperloop/components/footer.rb
class Footer < Hyperloop::Component
  def link_item(path)
    A(href: "/#{path}", style: {marginRight: 10}) { path.camelize }
  end
  render(DIV) do
    link_item(:all)
    link_item(:active)
    link_item(:completed)
  end
end

```

Save the file, and you will now have 3 links, that you will change the path between the three options.  

Here is how the changes work:
+ Hyperloop is just Ruby, you are free to use all of Ruby's rich feature set to structure your code. For example the `link_item` method is just a *helper* method to save us some typing.
+ The `link_item` method uses the `path` argument to construct an *Anchor* tag.
+ Hyperloop comes with a large portion of the rails active-support library.  For the text of the anchor tag we use the active-support method `camelize`.
+ Later we will add proper classes, but for now we use an inline style.  Notice that `margin-right` becomes `marginRight`, and that the integer 10 becomes `10px`.

What we really want here is for the links to simply change the route, without reloading the page.  To make this happen we will replace the anchor tag with the Router's NavLink component:

Change

```ruby

  A(href: "/#{path}", style: {marginRight: 10}) { path.camelize }

```

to

```ruby

  NavLink("/#{path}", style: {marginRight: 10}) { path.camelize }

```
After this change you will notice that changing routes *does not* reload the page, and after clicking to different routes, you can use the browsers forward and back buttons.

How does it work?  The `NavLink` component reacts to a click just like an anchor tag, but instead of changing the window's URL directly, it updates the *HTML5 history object.*  Associated with this history is a (you guessed it I hope) a *state*.  So when the history changes it causes any components depending on the current URL to be re-rendered.

### Chapter 8: Create a Basic EditItem Component
So far we can mark Todos as completed, delete them, and filter them.  Now we create an `EditItem` component so we can change the Todo title.

Add a new component like this:

```ruby

# app/hyperloop/components/edit_item.rb
class EditItem < Hyperloop::Component
  param :todo
  render do
    INPUT(value: params.todo.title)
    .on(:change) do |evt|
      params.todo.title = evt.target.value
    end
    .on(:key_down) do |evt|
      next unless evt.key_code == 13
      params.todo.save
    end
  end
end

```

Before we use this component let's understand how it works.
+ It receives a `todo` param which will be edited by the user;
+ The `title` of the todo is displayed in an input;
+ As the user types, `change` events are fired which will update the title and
+ When the user types the enter key (key code 13) the todo is saved
Now update the `TodoItem` component replacing

```ruby

  SPAN { params.todo.title }

```

with

```ruby

  EditItem(todo: params.todo)

```
Try it out by changing the text of some our your Todos followed by the enter key.  Then refresh the page to see that the Todos have changed.

### Chapter 9: Adding State to a Component, Defining Custom Events, and a Lifecycle Callback.
This all works, but its hard to use.  There is no feed back indicating that a Todo has been saved, and there is no way to cancel after starting to edit.
We can make the user interface much nicer by adding *state* (there is that word again) to the `TodoItem`.
We will call our state `editing`.  If `editing` is true, then we will display the title in a `EditItem` component, otherwise we will display it in a `LABEL` tag.
The user will change the state to `editing` by double clicking on the label.  When the user saves the Todo, we will change the state of `editing` back to false.
Finally we will let the user *cancel* the edit by movig the focus away (the `blur` event) from the `EditItem`.
To summarize:
+ User double clicks on any Todo title: editing changes to `true`.
+ User saves the Todo being edited: editing changes to `false`.
+ User changes focus away (`blur`) from the Todo being edited: editing changes to `false`.
In order to accomplish this our `EditItem` component is going to communicate via two callbacks - `on_save` and `on_cancel` - with the parent component.  We can think of these callbacks as custom events, and indeed as we shall see they will work just like any other event.
Add the following 5 lines to the `EditItem` component like this:

```ruby

# app/hyperloop/components/edit_item.rb
class EditItem < Hyperloop::Component
  param :todo
  param :on_save, type: Proc               # add
  param :on_cancel, type: Proc             # add
  after_mount { Element[dom_node].focus }  # add
  render do
    INPUT(value: params.todo.title)
    .on(:change) do |evt|
      params.todo.title = evt.target.value
    end
    .on(:key_down) do |evt|
      next unless evt.key_code == 13
      params.todo.save
      params.on_save                       # add
    end
    .on(:blur) { params.on_cancel }        # add
  end
end

```

The first two lines add our callbacks.  In HyperReact (and React.js) callbacks are just params.  Giving them `type: Proc` and beginning their name with `on_` means that HyperReact will treat them syntactically like events (as we will see.)  

The next line uses one of several *Lifecycle Callbacks*.  In this case we need to move the focus to the `EditItem` component after is mounted.  The `Element` class is Hyperloop's jQuery wrapper, and `dom_node` is the method that returns the actual dom node where this instance of the component is mounted.

The `params.on_save` line will call the provided callback.  Notice that because we declared `on_save` as type `Proc`, when we refer to it in the component it invokes the callback rather than returning the value.  for example, if we had left off `type: Proc` we would have to say `params.on_save.call`.

Finally we add the `blur` event handler and simply transform it into our custom `cancel` event.

Now we can update our `TodoItem` component to be a little state machine, which will react to three events:  `double_click`, `save` and `cancel`.

```ruby

# app/hyperloop/components/todo_item.rb
class TodoItem < Hyperloop::Component
  param :todo
  state editing: false
  render(LI) do
    if state.editing
      EditItem(todo: params.todo)
      .on(:save, :cancel) { mutate.editing false }
    else
      INPUT(type: :checkbox, checked: params.todo.completed)
      .on(:click) { params.todo.update(completed: !params.todo.completed) }
      LABEL { params.todo.title }
      .on(:double_click) { mutate.editing true }
      A { ' -X-' }
      .on(:click) { params.todo.destroy }
    end
  end
end

```

First we declare a *state variable* called `editing` that is initialized to `false`.

We have already used a lot of states that are built into the HyperModel and HyperRouter.  The state machines in these complex objects are built out of simple state variables like the `editing`.

State variables are *just like instance variables* with the added power that when they change, any dependent components will be updated with the change.

You read a state variable using the `state` method (similar to the `params` method) and you change state variables using the `mutate` method.  Whenever you want to change a state variable whether its a simple assignment or changing the internal value of a complex structure like a hash or array you use the `mutate` method.

Lets read on:  Next we see `if state.editing...`.  When the component executes this if statement, it reads the value of the `editing` state variable and will either render the `EditItem` or the input, label, and anchor tags.  In this way `editing` state variable is acting no different than any other Ruby instance variable.  *But here is the key:  The component now knows that if the value of the editing state changes, it must re-render this TodoItem.  When state variables are referenced by a component the component will keep track of this, and will re-rerender when the state changes.*

Because `editing` starts off false, when the TodoItem first mounts, it renders the input, label, and anchor tags.  Attached to the label tag is a `double_click` handler which does one thing:  *mutates* the editing state.  This then causes the component to re-render, and now instead of the three tags, we will render the `EditItem` component.

Attached to the `EditItem` component is the `save` and `cancel` handler (which is shared between the two events) that *mutates* the editing state, setting it back to false.

Notice that just as you read params using the `params` method, you read state variables using the `state` method.  Note that `state` is singular because we commonly think of the 'state' of an object as singular entity.

### Chapter 10: Using EditItem to create new Todos

Our EditItem component has a good robust interface.  It takes a Todo, and lets the user edit the title, and then either save or cancel, using two event style callbacks to communicate back outwards.

Because of this we can easily reuse EditItem to create new Todos.  Not only does this save us time, but it also insures that the user interface acts consistently.

We have no way for a user to enter a new Todo.  At the top of our little Todo App there should be 'new' Todo waiting for the user to enter a title and hit return to save.

We can reuse our EditItem component by updating the `Header` component like this:

```ruby

# app/hyperloop/components/header.
class Header < Hyperloop::Component
  state(:new_todo) { Todo.new }
  render(DIV) do
    EditItem(todo: state.new_todo)
    .on(:save) { mutate.new_todo Todo.new }
  end
end

```

What we have done is create a state variable called `new_todo` and we have initialized it using a block that will return `Todo.new`.  The reason we use a block is to insure that we don't call `Todo.new` until after the system is loaded, at which point all state initialization blocks will be run.  A good rule of thumb is to use the block notation unless the initial value is a constant.

Then we pass the value of the state variable to EditItem, and when it is saved, we generate another new Todo and save it the `new_todo` state variable.

Notice `new_todo` is a state variable that is used in Header, so when it is mutated, it will cause a re-render of the Header, which will then pass the new value of `new_todo`, to EditItem, causing that component to re-render.  

We don't care if the user cancels the edit, so we simply don't provide a `:cancel` event handler.

### Chapter 11: Adding Styling

We are just going to steal the style sheet from the benchmark Todo app, and add it to our assets.

**GO GRAB THE FILE** at https://github.com/JustinManno/todo-tutorial/blob/hyperloop/app/assets/stylesheets/todo.css
you will need to make a file in app/assests/stylesheets called, todo.css. paste the file there. Make sure to make it a css file.

You will have to refresh the page after changing the style sheet

Now its a matter of updating the classes (which are passed via the class parameter) and also changing some of the DIVs to other HTML tags.

Lets do the `App` component.  With styling it will look like this:

```ruby

# app/hyperloop/components/show.rb
class App < Hyperloop::Router
  history :browser
  route do
    SECTION(class: 'todo-app') do # change to SECTION and add class
      Header()
      Route('/:scope', mounts: Index)
      Footer()
    end
  end
end

```

Now the `Header`:

```ruby

# app/hyperloop/components/header.rb
class Header < Hyperloop::Component
  state(:new_todo) { Todo.new }
  render(HEADER, class: :header) do # change from DIV to HEADER, and add class
    H1 { 'todos' } # Add this H1 tag.
    EditItem(todo: state.new_todo, class: 'new-todo') # add class
    .on(:save) { mutate.new_todo Todo.new }
  end
end

```

The `Footer` components needs have `UL` added to hold the links nicely, and we can also use a built-in feature of `NavLinks` that will highlight the currently selected link:

```ruby

# app/hyperloop/components/footer.rb
class Footer < Hyperloop::Component
  include HyperRouter::ComponentMethods
  def link_item(path)
    # wrap the NavLink in a LI and...
    # pass the class (selected) to be added when the current
    # path equals the NavLink's path.
    LI { NavLink("/#{path}", active_class: :selected) { path.camelize } }
  end
  render(DIV, class: :footer) do # add class
    UL(class: :filters) do # make links into a UL
      link_item(:all)
      link_item(:active)
      link_item(:completed)
    end
  end
end

```

Wrap `Index`'s `UL` in a `SECTION` and add the `todo-list` class to the `UL`

```ruby
# app/hyperloop/components/index.rb
class Index < Hyperloop::Router::Component
  render(SECTION, class: :main) do # wrap the UL in a section with class main
    UL(class: 'todo-list') do # add the class
      Todo.send(match.params[:scope]).each do |todo|
        TodoItem(todo: todo)
      end
    end
  end
end

```

Add classes to the TodoItem's list-item, input, and anchor tags, as well as to the `EditItem` component:

```ruby

# app/hyperloop/components/todo_item.rb
class TodoItem < Hyperloop::Component
  param :todo
  state editing: false
  render(LI, class: 'todo-item') do
    if state.editing
      EditItem(class: :edit, todo: params.todo)
      .on(:save, :cancel) { mutate.editing false }
    else
      INPUT(type: :checkbox, class: :toggle, checked: params.todo.completed)
      .on(:click) { params.todo.update(completed: !params.todo.completed) }
      LABEL { params.todo.title }
      .on(:double_click) { mutate.editing true }
      A(class: :destroy) # also remove the { '-X-' } placeholder
      .on(:click) { params.todo.destroy }
    end
  end
end

```
Finally for the EditItem component we are going to let the caller specify the class.  To keep things compatible with React.js components we name the param `className`, which will receive any classes passed to it.

```ruby

# app/hyperloop/components/edit_item.rb
class EditItem < Hyperloop::Component
  param :todo
  param :on_save, type: Proc
  param :on_cancel, type: Proc
  param :className # recieves class params
  after_mount { Element[dom_node].focus }
  render do
    # pass the className param as the INPUT's class
    INPUT(class: params.className, value: params.todo.title)
    .on(:change) do |evt|
      params.todo.title = evt.target.value
    end
    .on(:key_down) do |evt|
      next unless evt.key_code == 13
      params.todo.save
      params.on_save
    end
    .on(:blur) { params.on_cancel }
  end
end

```

### Chapter 12: Other Features


+ **Show How Many Items Left In Footer**
This is just a span that we add before the link tags list in the Footer component:

```ruby

  ...
  render(DIV, class: :footer) do
    SPAN(class: 'todo-count') do
      "#{Todo.active.count} item#{'s' if Todo.active.count != 1} left"
    end
    UL(class: :filters) do
  ...

```
+ **Add 'placeholder' Text To Edit Item**
EditItem should display a meaningful placeholder hint if the title is blank:

```ruby

  ...
  INPUT(class: params.className, value: params.todo.title, placeholder: "What is left to do today?")
  ...

```
+ **Don't Show the Footer If There are No Todos**
In the `App` component add a guard so that we won't show the Footer if there are no Todos:

```ruby

  ...
      Footer() unless Todo.count.zero?
  ...

```
+ **Add a Root Route**
The home path ('/') should redirect to the '/all' path:

```ruby

# app/hyperloop/components/app.rb
class App < Hyperloop::Router
  history :browser
  route do
    SECTION(class: 'todo-app') do
      Header()
      # we have to have exact: true otherwise it will match /xxx
      Route('/', exact: true) { Redirect('/all') }
      Route('/:scope', mounts: Index)
      Footer() unless Todo.count.zero?
    end
  end
end

```


Congratulations! you have completed the tutorial.
