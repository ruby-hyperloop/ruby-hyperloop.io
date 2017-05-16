---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">D</span>eploy on VPS Tutorial

#### Writing this tutorial state : In progress

#### Step 1: Running your app in production mode

Before deploying your app on a VPS, we will test it locally with the `RAILS_ENV=production` mode.

Note: For now Hyperloop is not running in production mode with the default configuration parameters. It is needed to use hyperloop with the advanced configuration mode (See here to know to configure: [{ Advanced configuration }](/docs/advancedconfiguration)).

Once you setted up your Hyperloop app with the advanced configuration parameters, we will update some files:

```ruby
#config/application.rb

	config.autoload_paths   -= %W(#{config.root}/app/hyperloop)
    config.eager_load_paths -= %W(#{config.root}/app/hyperloop)

    config.eager_load_paths += %W(#{config.root}/app/models)
    config.autoload_paths += %W(#{config.root}/app/models)
    
    config.eager_load_paths += %W(#{config.root}/app/hyperloop/operations)
    config.autoload_paths   += %W(#{config.root}/app/hyperloop/operations)
```

```ruby
#config/environments/production.rb

	config.assets.digest = true
	config.public_file_server.enabled = true

```

```ruby
#config/initializers/assets.rb

	Rails.application.config.assets.precompile += %w( react-server.js components.js )

```

Then run the command:

```
RAILS_ENV=production rails assets:precompile
```

When every assets are precompiled, you can run your app:

```
RAILS_ENV=production rails s
```

You can find the complete source code of a Helloworld sample Hyperloop app already setted up for production mode here: [{ Hyperloop with Advanced configuration and production mode}](https://github.com/ruby-hyperloop/hyperloop-rails-helloworld-advancedconfig)

#### Step 2: Deploying on VPS