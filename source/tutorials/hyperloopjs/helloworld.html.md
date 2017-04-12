---
title: Tutorials, Videos & Quickstarts
---


## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">H</span>elloWorld Tutorial

![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-helloworld/master/hyperloophelloworldscreenshot.png)


You can find the complete source code of this tutorial here: [Hyperloop.js Helloworld app](https://github.com/ruby-hyperloop/hyperloop-js-helloworld)

### Tutorial

First add React, JQuery, `hyperloop.js` and `opal-compiler.js` to your HTML page:

```html
<head>
  <!-- React and JQuery -->
  <script src="https://unpkg.com/react@15/dist/react.min.js"></script>
  <script src="https://unpkg.com/react-dom@15/dist/react-dom.min.js"></script>
  <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>

  <!-- Opal and Hyperloop -->
  <script src="https://rawgit.com/ruby-hyperloop/hyperloop-js/master/opal-compiler.min.js"></script>
  <script src="https://rawgit.com/ruby-hyperloop/hyperloop-js/master/hyperloop.min.js"></script>
</head>
```

Next, specify your ruby code inside script tags.

```ruby
<script type="text/ruby">

class Helloworld < Hyperloop::Component

	state show_field: false
	state field_value: ""

	render(DIV) do
	  show_button
	  DIV(class: 'formdiv') do
	    show_input
	    H1 { "#{state.field_value}" }
	  end if state.show_field
	end

	def show_button
	  BUTTON(class: 'btn btn-info') do
	    state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
	  end.on(:click) { mutate.show_field !state.show_field }
	end

	def show_input
	  
	  H4 do 
	    SPAN {'Please type '}
	    SPAN(class: 'colored') {'Hello World'}
	    SPAN {' in the input field below :'}
	    BR {}
	    SPAN{'Or anything you want (^̮^)'}
	  end
	  
	  INPUT(type: :text, class: 'form-control').on(:change) do |e|
	    state.field_value! e.target.value
	  end
	end

	def show_text
	  H1 { "#{state.field_value}" }
	end

end

</script>

```

Finally, mount your Component(s) as a DOM element and specify the Component and parameters using data-tags:

```html
<body>
  <div data-hyperloop-mount="Helloworld"
       data-name="">
  </div>
</body>
```