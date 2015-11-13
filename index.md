---
layout: page
title: Use Ruby to build Reactive User Interfaces
id: home
---

<section class="light home-section">
  <div class="marketing-row">
    <div class="marketing-col">
      <h3>Pure Ruby</h3>
      <p>
        React.rb lets you build beautiful interactive user interfaces using the same Ruby language running your server side code.  React.rb replaces JS code, HTML,
        templating languages, and complex frameworks with one simple system.
      </p>
    </div>
    <div class="marketing-col">
      <h3>React + Ruby</h3>
      <p>
        The power and simplicity of React with a great easy to use Ruby DSL.  React.rb frees you up to do what you do best - building great apps.
      </p>
    </div>
    <div class="marketing-col">
      <h3>Simplicity</h3>
      <p>
        One language.  One simple model.  Under the hood React.rb takes care of all the details for you.  The same ruby code runs on the server to deliver pages
        fast, and then keeps running on the client to handle your user interactions.  
      </p>
    </div>
  </div>
</section>
<hr class="home-divider" />
<section class="home-section">
  <div id="examples">
    <div class="example">
      <h3>A Simple Component</h3>
      <p>
        React components are Ruby classes that include the `React::Component` mixin.  The `render` method is called to generate the components HTML.
      </p>
      <p><i>You may click any code component in this document to bring up a playground try out the code for yourself</i></p>
<a onclick="playground(this)"  data-link="http://fkchang.github.io/opal-playground/?code:class%20HelloWorld%0A%0A%20%20include%20React%3A%3AComponent%0A%20%20required_param%20%3Avisitor%0A%0A%20%20def%20render%0A%20%20%20%20%22Hello%20there%20%23%7Bvisitor%7D%22%0A%20%20end%0Aend%0A%0AReact.render(%0A%20%20React.create_element(%0A%20%20%20%20HelloWorld%2C%20%7Bvisitor%3A%20%22world%22%7D)%2C%20%0A%20%20Element%5B'%23content'%5D)%0A%0A%0A&html_code=%3Cdiv%20id%3D'content'%3E%3C%2Fdiv%3E&css_code=body%20%7B%0A%20%20background%3A%20%23eeeeee%3B%0A%7D%0A">
{% highlight ruby %}
class HelloWorld

  include React::Component
  required_param :visitor

  def render
    "Hello there #{visitor}"
  end
end

React.render(React.create_element(HelloWorld, {visitor: "world"}), Element['#content'])
{% endhighlight %}
</a>
    </div>
    <div class="example">
      <h3>A Stateful Component</h3>
      <p>
        In addition to taking input data (such as the `visitor` param), a
        component can maintain internal state data, which are like <i>reactive</i> instance variables.
        When a component's state data changes, the rendered markup will be
        updated by re-invoking the `render` method.
      </p>
<a onclick="playground(this)" data-link="http://fkchang.github.io/opal-playground/?code:class%20Ticker%0A%20%20include%20React%3A%3AComponent%0A%0A%20%20define_state%20ticks%3A%200%0A%20%20%0A%20%20after_mount%20do%0A%20%20%20%20%40timer%20%3D%20every(1)%20%7Bticks!%20ticks%2B1%7D%0A%20%20end%0A%20%20%0A%20%20before_unmount%20do%0A%20%20%20%20%40timer.stop%0A%20%20end%0A%20%20%0A%20%20def%20render%0A%20%20%20%20div%20%7B%22Seconds%20Elapsed%3A%20%23%7Bticks%7D%22%7D%0A%20%20end%0A%20%20%0Aend%0A%0AReact.render(React.create_element(Ticker)%2CElement%5B%27%23content%27%5D)&html_code=%3Cdiv%20id%3D%27content%27%3E%3C%2Fdiv%3E&css_code=body%20%7B%0A%20%20background%3A%20%23eeeeee%3B%0A%7D%0A">
{% highlight ruby %}
class Ticker
  include React::Component

  define_state ticks: 0

  after_mount do
    @timer = every(1) {ticks! ticks+1}
  end

  before_unmount do
    @timer.stop
  end

  def render
    div {"Seconds Elapsed: #{ticks}"}
  end

end

React.render(React.create_element(Ticker),Element['#content'])
{% endhighlight %}
</a>
    </div>
    <div class="example">
      <h3>An Application</h3>
      <p>
        Using params and state, we can put together a small Todo application.
        This example uses two states to track the current list of items as well as
        the text that the user has entered.
      </p>
<a onclick="playground(this)" data-link="http://fkchang.github.io/opal-playground/?code:class%20TodoList%0A%20%20%0A%20%20include%20React%3A%3AComponent%0A%20%20%0A%20%20required_param%20%3Aitems%2C%20type%3A%20%5BString%5D%0A%20%20%0A%20%20def%20render%0A%20%20%20%20ul%20do%0A%20%20%20%20%20%20items.each_with_index%20do%20%7Citem%2C%20index%7C%0A%20%20%20%20%20%20%20%20li(key%3A%20%22item%20-%20%23%7Bindex%7D%22)%20%7B%20item%20%7D%0A%20%20%20%20%20%20end%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0Aclass%20TodoApp%20%0A%20%20%0A%20%20include%20React%3A%3AComponent%0A%20%20%0A%20%20define_state%20items%3A%20%5B%5D%2C%20text%3A%20%22%22%0A%0A%20%20def%20render%0A%20%20%20%20div%20do%0A%20%20%20%20%20%20h3%20%7B%20%22TODO%22%20%7D%0A%20%20%20%20%20%20TodoList%20items%3A%20items%0A%20%20%20%20%20%20div%20do%0A%20%20%20%20%20%20%20%20input(value%3A%20text).on(%3Achange)%20do%20%7Ce%7C%20%0A%20%20%20%20%20%20%20%20%20%20text!%20e.target.value%0A%20%20%20%20%20%20%20%20end%0A%20%20%20%20%20%20%20%20button%20%7B%20%22Add%20%23%23%7Bitems.length%2B1%7D%22%20%7D.on(%3Aclick)%20do%20%7Ce%7C%20%0A%20%20%20%20%20%20%20%20%20%20items!%20(items%20%2B%20%5Btext!(%22%22)%5D)%0A%20%20%20%20%20%20%20%20end%0A%20%20%20%20%20%20end%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0AReact.render(React.create_element(TodoApp)%2CElement%5B'%23content'%5D)%0A&html_code=%3Cdiv%20id%3D%22content%22%3E%3C%2Fdiv%3E%0A&css_code=body%20%7B%0A%20%20background%3A%20%23eeeeee%3B%0A%7D%0A">
{% highlight ruby %}      
class TodoList

  include React::Component

  required_param :items, type: [String]

  def render
    ul do
      items.each_with_index do |item, index|
        li(key: "item - #{index}") { item }
      end
    end
  end
end

class TodoApp

  include React::Component

  define_state items: [], text: ""

  def render
    div do
      h3 { "TODO" }
      TodoList items: items
      div do
        input(value: text).on(:change) do |e|
          text! e.target.value
        end
        button { "Add ##{items.length+1}" }.on(:click) do |e|
          items! (items + [text!("")])
        end
      end
    end
  end
end

React.render(React.create_element(TodoApp),Element['#content'])
{% endhighlight %}
</a>
    </div>
    <div class="example">
      <h3>A Component Using External Plugins</h3>
      <p>
        React is flexible and provides hooks that allow you to interface with
        other libraries and frameworks. This example uses **marked**, an external
        Markdown library, to convert the textarea's value in real-time.
      </p>
      <div id="markdownExample"></div>
    </div>
  </div>
  <script src="/react/js/marked.min.js"></script>
  <script src="/react/js/examples/hello.js"></script>
  <script src="/react/js/examples/timer.js"></script>
  <script src="/react/js/examples/todo.js"></script>
  <script src="/react/js/examples/markdown.js"></script>
</section>
<hr class="home-divider" />
<section class="home-bottom-section">
  <div class="buttons-unit">
    <a href="docs/getting-started.html" class="button">Get Started</a>
    <a href="downloads.html" class="button">Download React v{{site.react_version}}</a>
  </div>
</section>
