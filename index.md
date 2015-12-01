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
        React.rb lets you build beautiful interactive user interfaces using the same Ruby language running your server side code.  React.rb replaces JS code, JSX, HTML,
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
        React components can be defined by subclassing `React::Component::Base`.  The `render` method is called to generate the components HTML.
      </p>
      <div id="helloExample"></div>
    </div>
    <div class="example">
      <h3>A Stateful Component</h3>
      <p>
        In addition to taking input data (such as the `visitor` param), a
        component can have state variables, which are like <i>reactive</i> instance variables.
        When a component's state changes, the markup will be
        updated by automatically by re-invoking the `render` method.
      </p>
      <div id="timerExample"></div>
    </div>
    <div class="example">
      <h3>An Application</h3>
      <p>
        Using params and state, we can put together a small Todo application.
        This example uses two state variables to track the current list of items and
        the text that the user has entered.
      </p>
      <div id="todoExample"></div>
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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/0.3.5/marked.min.js"></script>
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
