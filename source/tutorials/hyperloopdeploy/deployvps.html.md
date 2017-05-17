---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">D</span>eploy on VPS Tutorial

#### Writing this tutorial state : In progress

#### Step 1: Running your app in production mode

Before deploying your app on a production server you will want to test it locally with the RAILS_ENV=production mode.

The primary difference is that in production you will want to override Hyperloops auto-loader and use normal Rails precompilation.

The first step is turn off Hyperloop's autoloading.
See [{ Advanced configuration }](/docs/advancedconfiguration) for details.

Once you have manually set up your Hyperloop app, we will need to update some files, so Rails knows what to precompile


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

Once these changes are made, to test the setup on your local machine you will need to manually precompile your assets, by running the following:

```
RAILS_ENV=production rails assets:precompile
```

Once the assets are precompiled, you can run your app:

```
RAILS_ENV=production rails s
```

You can find the complete source code of a Helloworld sample Hyperloop app already set up for production mode here: [{ Hyperloop with Advanced configuration and production mode}](https://github.com/ruby-hyperloop/hyperloop-rails-helloworld-advancedconfig)

#### Step 2: Deploying on VPS