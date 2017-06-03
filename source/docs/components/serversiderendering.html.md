---
title: Components
---
## Server-side rendering (or Prerendering)

**Prerendering is controllable at three levels:**

######In the rails hyperloop initializer you can say:

 ```ruby
 Hyperloop.configuration do |config|
   config.prerendering = :off # :on by default
 end
 ```


######In a route you can override the config setting by setting a default for hyperloop_prerendering:

```ruby
get '/some_page', to: 'hyperloop#some_page', defaults: {hyperloop_prerendering: :off} # or :on
```

This allows you to override the prerendering option for specific pages. For example the application may have prererendering off by default (via the config setting) but you can still turn it on for a specific page.

######You can override the route, and config setting using the hyperloop-prerendering query param:

```html
http://localhost:3000/my_hyper_app/some_page?hyperloop-prerendering=off
```

This is useful for development and testing

NOTE: in the route you say hyperloop_prererendering but in the query string its hyperloop-prerendering (underscore vs. dash). This is because of rails security protection when using defaults.