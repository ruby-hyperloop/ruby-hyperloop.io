---
title: Models
---

## Common Errors

- **No policy class**
  If you don't define a policy file, nothing will happen because nothing will get connected. By default Hyperloop will look for a `ApplicationPolicy` class.

- **Wrong version of pusher-fake**  (pusher-fake/base vs. pusher-fake/rspec) See the Pusher-Fake gem repo for details.

- Forgetting to add `require pusher` in application.js file
this results in an error like this:
  ```text
  Exception raised while rendering #<TopLevelRailsComponent:0x53e>
      ReferenceError: Pusher is not defined
  ```
  To resolve make sure you `require 'pusher'` in your application.js file if using pusher.  DO NOT require pusher from your components manifest as this will cause prerendering to fail.

- **No create/update/destroy policies**
  You must explicitly allow changes to the Models to be made by the client. If you don't you will see 500 responses from the server when you try to update. To open all access do this in your application policy: `allow_change(to: :all, on: [:create, :update, :destroy]) { true }`

- **Cannot connect to real pusher account**
  If you are trying to use a real pusher account (not pusher-fake) but see errors like this
  ```text
  pusher.self.js?body=1:62 WebSocket connection to
  'wss://127.0.0.1/app/PUSHER_API_KEY?protocol=7&client=js&version=3.0.0&flash=false'
  failed: Error in connection establishment: net::ERR_CONNECTION_REFUSED
  ```
  Check to see if you are including the pusher-fake gem.
  Hyperloop will always try to use pusher-fake if it sees the gem included.  Remove it and you should be good to go.  See [issue #5](https://github.com/hyper-react/HyperMesh/issues/5) for more details.

- **Cannot connect with ActionCable.**
  Make sure that `config.action_cable.allowed_request_origins` includes the url you use for development (including the port) and that you are using `Puma`.

- **Attributes are not being converted from strings, or do not have their default values**
Eager loading is probably turned off.  Hyperloop needs to eager load `hyperloop/models` so it can find all the column information for all Isomorphic models.

- **When starting rails you get a message on the rails console `couldn't find file 'browser'`**
The `hyper-component` v0.10.0 gem removed the dependency on opal-browser.  You will have to add the 'opal-browser' gem to your Gemfile.

- **On page load you get a message about super class mismatch for `DummyValue`**
You are still have the old `reactive-record` gem in your Gemfile, remove it from your gemfile and your components manifest.

- **On page load you get a message about no method `session` for `nil`**
You are still referencing the old reactive-ruby or reactrb gems either directly or indirectly though a gem like reactrb-router.  Replace any gems like `reactrb-router` with `hyper-router`.  You can also just remove `reactrb`, as `hyper-model` will be included by the `hyper-model` gem.

- **You keep seeing the message `WebSocket connection to 'ws://localhost:3000/cable' failed: WebSocket is closed before the connection is established.`** every few seconds in the console.
  There are probably lots of reasons for this, but it means ActionCable can't get itself going.  One reason is that you are trying to run with Passenger instead of Puma, and trying to use `async` mode in cable.yml file.  `async` mode requires Puma.
