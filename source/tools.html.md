# Tools, Debugging and Testing

## Tools

As most of the Hyperloop gems use [Opal](http://opalrb.org/), you have the whole Opal universe of tools available to you. The following two have been designed to work with Reactrb:

### [Opal Hot Reloader](https://github.com/fkchang/opal-hot-reloader)

For pure programmer joy, no more page refreshes.

### [Opal Console](https://github.com/fkchang/opal-console)

Opal in your browser. Great for testing.

## Debugging

There are a few simple debugging techniques:

### Puts is your friend

Anywhere in your Reactrb code you can simply `puts any_value` which will display the contents of the value in the browser console. This can help you understand React program flow as well as how data changes over time.

```ruby
class Thing < React::Component::Base
  param initial_mode: 12

  before_mount do
    state.mode! params.initial_mode
    puts "before_mount params.initial_mode=#{params.initial_mode}"
  end

  after_mount do
    @timer = every(60) { force_update! }
    puts "after_mount params.initial_mode=#{params.initial_mode}"
  end

  render do
    div(class: :time) do
      puts "render params.initial_mode=#{params.initial_mode}"
      puts "render state.mode=#{state.mode}"
      ...
      end.on(:change) do |e|
        state.mode!(e.target.value.to_i)
        puts "on:change e.target.value.to_i=#{e.target.value.to_i}"
        puts "on:change (too high) state.mode=#{state.mode}" if state.mode > 100
      end
    end
  end
end
```
### JavaScript Console

At any time during program execution you can breakout into the JavaScript console by simply adding a line of back-ticked JavaScript to your ruby code:

```ruby
`debugger;`
```
If you have source maps turned on you will then be able to see your ruby code (and the compiled JavaScript code) and set browser breakpoints, examine values and continue execution. See [Opal Source Maps](http://opalrb.org/docs/guides/v0.10.1/source_maps.html) if you are not seeing source maps.

You can also inspect ruby objects from the JavaScript console. [Here are three tricks](http://dev.mikamai.com/post/103047475349/3-tricks-to-debug-opal-code-from-your-browser).

## Testing

... need help here please ...
