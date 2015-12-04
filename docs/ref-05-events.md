---
id: events
title: Event System
permalink: events.html
prev: tags-and-attributes.html
next: dom-differences.html
---

## React::Event

Your event handlers will be passed instances of `React::Event`, a wrapper around react.js's SyntheticEvent which in turn is a cross browser wrapper around the browser's native event. It has the same interface as the browser's native event, including `stopPropagation()` and `preventDefault()`, except the events work identically across all browsers.

The following section has **not** been updated from React.js, but you can apply the following rules:  method and event names are all snake cased, i.e. `defaultPrevented` becomes `default_prevented`.  Event names do not begin with `on`, thus `onKeyPress` becomes :key_press.

For example:

```ruby
class YouSaid < React::Component::Base
  def render 
    input(value: state.value).
    on(:key_down) do |e|
      alert "You said: #{state.value}" if e.key_code == 13 
    end.
    on(:change) do |e|
      state.value! e.target.value
    end
  end
end
```
      

If you find that you need the underlying browser event for some reason use the `native_event`.

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

## Event pooling

The underlying React `SyntheticEvent` is pooled. This means that the `SyntheticEvent` object will be reused and all properties will be nullified after the event callback has been invoked.
This is for performance reasons.
As such, you cannot access the event in an asynchronous way.

## Supported Events

React normalizes events so that they have consistent properties across
different browsers.


### Clipboard Events

Event names:

```ruby
:copy, :cut, :paste
```

Available Methods:

```ruby
clipboard_data -> (native DOMDataTransfer)
```


### Composition Events (not tested)

Event names:

```
:composition_end, :composition_start, :composition_update
```

Available Methods:

```ruby
data -> String
```

### Keyboard Events

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


### Focus Events

Event names:

```
:focus, :blur
```

Properties:

```ruby
related_target -> (Native DOMEventTarget)
```

These focus events work on all elements in the React DOM, not just form elements.

### Form Events

Event names:

```
onChange onInput onSubmit
```

For more information about the onChange event, see [Forms](/docs/forms.html).


### Mouse Events

Event names:

```
onClick onContextMenu onDoubleClick onDrag onDragEnd onDragEnter onDragExit
onDragLeave onDragOver onDragStart onDrop onMouseDown onMouseEnter onMouseLeave
onMouseMove onMouseOut onMouseOver onMouseUp
```

The `onMouseEnter` and `onMouseLeave` events propagate from the element being left to the one being entered instead of ordinary bubbling and do not have a capture phase.

Properties:

```javascript
boolean altKey
number button
number buttons
number clientX
number clientY
boolean ctrlKey
boolean getModifierState(key)
boolean metaKey
number pageX
number pageY
DOMEventTarget relatedTarget
number screenX
number screenY
boolean shiftKey
```


### Selection events

Event names:

```
onSelect
```


### Touch events

Event names:

```
onTouchCancel onTouchEnd onTouchMove onTouchStart
```

Properties:

```javascript
boolean altKey
DOMTouchList changedTouches
boolean ctrlKey
boolean getModifierState(key)
boolean metaKey
boolean shiftKey
DOMTouchList targetTouches
DOMTouchList touches
```


### UI Events

Event names:

```
onScroll
```

Properties:

```javascript
number detail
DOMAbstractView view
```


### Wheel Events

Event names:

```
onWheel
```

Properties:

```javascript
number deltaMode
number deltaX
number deltaY
number deltaZ
```

### Media Events

Event names:

```
onAbort onCanPlay onCanPlayThrough onDurationChange onEmptied onEncrypted onEnded onError onLoadedData onLoadedMetadata onLoadStart onPause onPlay onPlaying onProgress onRateChange onSeeked onSeeking onStalled onSuspend onTimeUpdate onVolumeChange onWaiting
```

### Image Events

Event names:

```
onLoad onError
```
