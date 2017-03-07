---
title: Configuration
---

## Configuration

Hyperloop configuration is kept in `config/initializers/Hyperloop.rb`.

A minimal Hyperloop configuration consists of a simple initializer file, and at least one *Policy* class that will *authorize* who gets to see what.


```ruby
# for rails this would go in: config/initializers/Hyperloop.rb
Hyperloop.configuration do |config|
  config.transport = :simple_poller # or :none, action_cable, :pusher - see below)
end
# for a minimal setup you will need to define at least one channel, which you can do
# in the same file as your initializer.
# Normally you would put these policies in the app/policies/ directory
class ApplicationPolicy
  # allow all clients to connect to the Application channel
  regulate_connection { true } # or always_allow_connection for short
  # broadcast all model changes over the Application channel *DANGEROUS*
  regulate_all_broadcasts { |policy| policy.send_all }
end
```
