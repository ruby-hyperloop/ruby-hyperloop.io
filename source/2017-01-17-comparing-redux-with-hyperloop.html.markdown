---
title: Comparing Redux with Hyperloop
date: 2017-01-17
tags:
---
@catmando

In trying to find how Hyperloop models and flux-stores relate, I was rereading the Redux tutorials.  After having been away from that for a while I was amazed how clean Hyperloop's HyperReact DSL is compared to the typical JSX code.

For example here is a comparison of [Redux TodoMVC](https://github.com/reactjs/redux/tree/master/examples/todomvc) and [Hyperloop TodoMVC](https://github.com/ruby-hyperloop/todo-tutorial) which provide the same Todo UI and function.  (* *note that the code presented is slightly different from the linked Hyperloop tutorial as it uses the most recent version of the DSL.*)

Here are the component code files, which are roughly divided the same way between the two apps.

| JS files  | React/Redux size | Hyperloop size |  Ruby Files |
|-----------|------------------|----------------|-------------|
| Footer.js | 71 | 29 | footer_link.rb, footer.rb |
| Header.js, MainSection.js  | 103 | 25 | index.rb |
| TodoItem.js | 65 | 21 | todo_item.rb |
| TodoTextInput.js | 53 | 20 | edit_item.rb |
|Total | 292 | 95 |


In addition there are the following "store/action/model" definition files.


| JS files | React/Redux size | Hyperloop size |  Ruby Files |
|-----------|-------------|-----------|--------|
| action/index.js | 8 | | |
| constants/... | 9 | | |
| reducers/todos.js | 55 | | |
| | | 4 | models/public/todo.rb |
| total | 72 | 4 |



|  | React/Redux | Hyperloop |
|---|---|---|
|Total | 364 | 99 |

Note that not only is the Hyperloop version less than 1/3 the size, it is persisting and synchronizing the todo list across multiple browsers!  

There is nothing wrong with more lines of code, as long as the extra code is adding extra comprehension and making the code easier to maintain.  Unfortunately, I would say this is not the case!

I looked specifically at the TodoItem.js (65 SLOC) file and compared it to todo_item.rb (21 SLOC) file.

First, there is a preamble in the JS file (4 lines) which does not exist in the ruby file.

```javascript
import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'
import TodoTextInput from './TodoTextInput'
```

Then we have the class wrapper which is essentially the same 2 lines in JS vs Ruby:

```javascript
export default class TodoItem extends Component {
...
}
```

```ruby
class TodoItem < React::Component::Base
...
end
```

Then we define the properties, and state (11 lines in JSX vs 3 in Ruby)

```javascript
  static propTypes = {
    todo: PropTypes.object.isRequired,
    editTodo: PropTypes.func.isRequired,
    deleteTodo: PropTypes.func.isRequired,
    completeTodo: PropTypes.func.isRequired
  }

  state = {
    editing: false
  }

```

```ruby
    param :todo, type: Todo
    define_state editing: false

```

The JS version is simply more verbose.  In addition the JS code has an additional 3 declarations for the `deleteTodo`, `editTodo` and `completeTodo` params.  Because Hyperloop uses ActiveRecord,  reactive (read flux) methods like `delete` and the `complete` accessor are built into the `Todo` model - no extra charge!  

In the JS file we now have 2 helper methods (13 SLOC) which don't exist in the Ruby version:

```javascript
  handleDoubleClick = () => {
    this.setState({ editing: true })
  }

  handleSave = (id, text) => {
    if (text.length === 0) {
      this.props.deleteTodo(id)
    } else {
      this.props.editTodo(id, text)
    }
    this.setState({ editing: false })
  }

```

These methods are defined in blocks directly in the Ruby render method, so there is a bit of a stylistic choice here.  If we had pulled them out as methods `handleDoubleClick` would also be three lines long, but `handleSave` would only be four lines, as once again ActiveRecord is going to make handling the Todo's internal state easier.

Finally we get to the `render` method.  In React/Redux it looks like this:
```javascript
  render() {
    const { todo, completeTodo, deleteTodo } = this.props

    let element
    if (this.state.editing) {
      element = (
        <TodoTextInput text={todo.text}
                       editing={this.state.editing}
                       onSave={(text) => this.handleSave(todo.id, text)} />
      )
    } else {
      element = (
        <div className="view">
          <input className="toggle"
                 type="checkbox"
                 checked={todo.completed}
                 onChange={() => completeTodo(todo.id)} />
          <label onDoubleClick={this.handleDoubleClick}>
            {todo.text}
          </label>
          <button className="destroy"
                  onClick={() => deleteTodo(todo.id)} />
        </div>
      )
    }

    return (
      <li className={classnames({
        completed: todo.completed,
        editing: this.state.editing
      })}>
        {element}
      </li>
    )
  }
```

Before we look at the details of these 34 lines (vs 15 in Ruby) there are some JS statements which are simply not needed in Ruby, and which really clutter up reading the code.  These are:

```javascript
    const { todo, completeTodo, deleteTodo } = this.props

    let element
    ...
      element = (
      ...
      )
      ...
      element = (
      ...
      )
    ...
    return (
      ...
    )
```

These 8 lines which are almost 25% of the JS render method, and add very little clarity to the method.  What do these 8 lines do?

First we reassign the props to intermediate constants presumably to save a little time, and to make it so we can shorten `this.props[:todo]` to just `todo`.  In Hyperloop you access props more directly using the `params` object which takes care of accessing and caching the property, so you would say `params.todo`.  *A note:  originally you could just say `todo` without the `params.` prefix, but it was determined that made the code harder to read.  So this behavior is being deprecated.  A case where more typing is helpful.*

Then (for stylistic reasons I assume) we compute the child of the `li` element before actually generating the element.  Perhaps the mix of JSX and JS code would quickly get confusing if nested too deeply?

Finally, you have to wrap the whole thing in a return statement, which is just an artifact of JS.

Basically what I see happening here is that JS/JSX is more verbose, so in order to add comprehension, the flow of the code is broken up, methods are added, and intermediate values are introduced.  The result is a snowball effect.

Here is complete ruby class for comparison.
```ruby
class TodoItem < React::Component::Base

  param :todo, type: Todo
  define_state editing: false

  render(LI, class: 'todo-item') do
    if state.editing
      EditItem(todo: todo).
      on(:save) do
        todo.delete if todo.text.blank?
        state.editing! false
      end.
      on(:cancel) { state.editing! false }
    else
      INPUT(class: :toggle, type: :checkbox, checked: params.todo.completed).
      on(:click) { params.todo.update(completed: !params.todo.completed }
      LABEL { params.todo.title }.on(:doubleClick) { state.editing! true }
      A(class: :destroy).on(:click) { params.todo.destroy }
    end
  end
end
```

and here is the complete JSX class:
```jsx
import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'
import TodoTextInput from './TodoTextInput'

export default class TodoItem extends Component {
  static propTypes = {
    todo: PropTypes.object.isRequired,
    editTodo: PropTypes.func.isRequired,
    deleteTodo: PropTypes.func.isRequired,
    completeTodo: PropTypes.func.isRequired
  }

  state = {
    editing: false
  }

  handleDoubleClick = () => {
    this.setState({ editing: true })
  }

  handleSave = (id, text) => {
    if (text.length === 0) {
      this.props.deleteTodo(id)
    } else {
      this.props.editTodo(id, text)
    }
    this.setState({ editing: false })
  }

  render() {
    const { todo, completeTodo, deleteTodo } = this.props

    let element
    if (this.state.editing) {
      element = (
        <TodoTextInput text={todo.text}
                       editing={this.state.editing}
                       onSave={(text) => this.handleSave(todo.id, text)} />
      )
    } else {
      element = (
        <div className="view">
          <input className="toggle"
                 type="checkbox"
                 checked={todo.completed}
                 onChange={() => completeTodo(todo.id)} />
          <label onDoubleClick={this.handleDoubleClick}>
            {todo.text}
          </label>
          <button className="destroy"
                  onClick={() => deleteTodo(todo.id)} />
        </div>
      )
    }

    return (
      <li className={classnames({
        completed: todo.completed,
        editing: this.state.editing
      })}>
        {element}
      </li>
    )
  }
}
```

I didn't intend this to be such a rant, and it probably sounds more negative than I intend this to be.

Hyperloop is built on top of React, which is a great library.  The problem is that JS just doesn't have the expressive power especially when it comes to meta-programming and creating DSLs that Ruby does.  Instead of a nice clean syntax the mix of HTML and JS presented by JSX is confusing, and to de-confuse things you add more code.  Furthermore, because Hyperloop is also built on tried and true of ActiveRecord, again you have an increase in comprehension with a reduction in code.
