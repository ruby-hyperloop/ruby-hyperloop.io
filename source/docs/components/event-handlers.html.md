---
title: Components
---
## Event Handlers

### Event Handling and Synthetic Events

With React you attach event handlers to elements using the `on` method. React ensures that all events behave identically in IE8 and above by implementing a synthetic event system. That is, React knows how to bubble and capture events according to the spec, and the events passed to your event handler are guaranteed to be consistent with [the W3C spec](http://www.w3.org/TR/DOM-Level-3-Events/), regardless of which browser you're using.

### Under the Hood: Event Delegation

React doesn't actually attach event handlers to the nodes themselves. When React starts up, it starts listening for all events at the top level using a single event listener. When a component is mounted or unmounted, the event handlers are simply added or removed from an internal mapping. When an event occurs, React knows how to dispatch it using this mapping. When there are no event handlers left in the mapping, React's event handlers are simple no-ops. To learn more about why this is fast, see [David Walsh's excellent blog post](http://davidwalsh.name/event-delegate).

## React::Event

Your event handlers will be passed instances of `React::Event`, a wrapper around react.js's `SyntheticEvent` which in turn is a cross browser wrapper around the browser's native event. It has the same interface as the browser's native event, including `stopPropagation()` and `preventDefault()`, except the events work identically across all browsers.

For example:

<div class="codemirror-live-edit"
  data-heading="Events"
  data-rows=13
  data-top-level-component="YouSaid">
<pre>
class YouSaid < Hyperloop::Component

  render(DIV) do
    INPUT(value: state.value).
    on(:key_down) do |e|
      alert "You said: #{state.value}" if e.key_code == 13
    end.
    on(:change) do |e|
      mutate.value e.target.value
    end
  end
end
</pre></div>

If you find that you need the underlying browser event for some reason use the `native_event`.  

In the following responses shown as (native ...) indicate the value returned is a native object with an Opal wrapper.  In some cases there will be opal methods available (i.e. for native DOMNode values) and in other cases you will have to convert to the native value
with `.to_n` and then use javascript directly.

Every `React::Event` has the following methods:

```ruby
bubbles                -> Boolean
cancelable             -> Boolean
current_target         -> (native DOM node)
default_prevented      -> Boolean
event_phase            -> Integer
is_trusted             -> Boolean
native_event           -> (native Event)
prevent_default        -> Proc
is_default_prevented   -> Boolean
stop_propagation       -> Proc
is_propagation_stopped -> Boolean
target                 -> (native DOMEventTarget)
timestamp              -> Integer (use Time.at to convert to Time)
type                   -> String
```

### Event pooling

The underlying React `SyntheticEvent` is pooled. This means that the `SyntheticEvent` object will be reused and all properties will be nullified after the event callback has been invoked. This is for performance reasons. As such, you cannot access the event in an asynchronous way.

### Supported Events

React normalizes events so that they have consistent properties across
different browsers.


#### Clipboard Events

Event names:

```ruby
:copy, :cut, :paste
```

Available Methods:

```ruby
clipboard_data -> (native DOMDataTransfer)
```


#### Composition Events (not tested)

Event names:

```ruby
:composition_end, :composition_start, :composition_update
```

Available Methods:

```ruby
data -> String
```

#### Keyboard Events

Event names:

```ruby
:key_down, :key_press, :key_up
```

Available Methods:

```ruby
alt_key                 -> Boolean
char_code               -> Integer
ctrl_key                -> Boolean
get_modifier_state(key) -> Boolean (i.e. get_modifier_key(:Shift)
key                     -> String
key_code                -> Integer
locale                  -> String
location                -> Integer
meta_key                -> Boolean
repeat                  -> Boolean
shift_key               -> Boolean
which                   -> Integer
```


#### Focus Events

Event names:

```ruby
:focus, :blur
```

Available Methods:

```ruby
related_target -> (Native DOMEventTarget)
```

These focus events work on all elements in the React DOM, not just form elements.

#### Form Events

Event names:

```ruby
:change, :input, :submit
```

#### Mouse Events

Event names:

```ruby
:click, :context_menu, :double_click, :drag, :drag_end, :drag_enter, :drag_exit
:drag_leave, :drag_over, :drag_start, :drop, :mouse_down, :mouse_enter,
:mouse_leave, :mouse_move, :mouse_out, :mouse_over, :mouse_up
```

The `:mouse_enter` and `:mouse_leave` events propagate from the element being left to the one being entered instead of ordinary bubbling and do not have a capture phase.

Available Methods:

```ruby
alt_key                 -> Boolean
button                  -> Integer
buttons                 -> Integer
client_x                -> Integer
number client_y         -> Integer
ctrl_key                -> Boolean
get_modifier_state(key) -> Boolean
meta_key                -> Boolean
page_x                  -> Integer
page_y                  -> Integer
related_target          -> (Native DOMEventTarget)
screen_x                -> Integer
screen_y                -> Integer
shift_key               -> Boolean
```

#### Selection events

Event names:

```ruby
onSelect
```


#### Touch events

Event names:

```ruby
:touch_cancel, :touch_end, :touch_move, :touch_start
```

Available Methods:

```ruby
alt_key                 -> Boolean
changed_touches         -> (Native DOMTouchList)
ctrl_key                -> Boolean
get_modifier_state(key) -> Boolean
meta_key                -> Boolean
shift_key               -> Boolean
target_touches          -> (Native DOMTouchList)
touches                 -> (Native DomTouchList)
```

#### UI Events

Event names:

```ruby
:scroll
```

Available Methods:

```ruby
detail -> Integer
view   -> (Native DOMAbstractView)
```


#### Wheel Events

Event names:

```ruby
wheel
```

Available Methods:

```ruby
delta_mode -> Integer
delta_x    -> Integer
delta_y    -> Integer
delta_z    -> Integer
```

#### Media Events

Event names:

```ruby
:abort, :can_play, :can_play_through, :duration_change,:emptied, :encrypted, :ended, :error, :loaded_data,
:loaded_metadata, :load_start, :pause, :play, :playing, :progress, :rate_change, :seeked, :seeking, :stalled,
:on_suspend, :time_update, :volume_change, :waiting
```

#### Image Events

Event names:

```ruby
:load, :error
```
