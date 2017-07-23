---
title: Advanced configuration with Ruby On Rails
---


# Advanced configuration with Ruby On Rails


## <a name="initializer">Initializer</a>

Hyperloop generator adds an initializer file:

```ruby
#config/initializers/hyperloop.rb

Hyperloop.configuration do |config|
  config.transport = :simple_poller
  config.prerendering = :off
  config.console_auto_start = false
  config.import 'bootstrap-sprockets', client_only: true
end
```

* **`config.transport = [ :none | :simple_poller | :action_cable | :pusher ]`** <br>Allows us to configure the way push notifications are configured. <br>More detail: [{ Configuring the Transport }](/docs/models/configuring-transport)

* **`config.prerendering = :off (:on by default)`** <br> Allows us to configure the way Server-side rendering works. <br>More detail: [{ Server-side rendering }](/docs/components/serversiderendering)

* **`config.console_auto_start = false`** <br> Allows us to turn off the Hyper-console debugging tool. <br>More detail: [{ Hyper-console }](/tools/hyperconsole/)

* **`config.compress_system_assets = false`** <br> Allows us to turn off the minifying of all Hyperloop system assets files. During the first boot of the Rails Env, Hyperloop assets files will not be minified).

* **`config.import 'filename-to-import'`** <br> Allows us to import any Javascript librairies (they can also be imported or required in your Rails `app/javascripts/application.js` file)

* **`config.cancel_import('filename-to-import')`** <br> Allows us to cancel the importation into the Ruby on Rails manifests files. Generally files are imported automatically by Hyperloop GEMS or manually by the previous 'config.import` param.

## <a name="policies">Policies</a>

Hyperloop generator adds a policy default file:

```ruby
#app/policies/application_policy.rb

class Hyperloop::ApplicationPolicy
  # Allow any session to connect:
  always_allow_connection
  # Send all attributes from all public models
  regulate_all_broadcasts { |policy| policy.send_all }
  # Allow all changes to public models
  allow_change(to: :all, on: [:create, :update, :destroy]) { true }
end unless Rails.env.production?
```

Hyperloop uses Policies to regulate what connections are opened between clients and the server and what data is distributed over those connections.

More detail in the documentation: [{ Configuring the policies }](/docs/policies/authorization)


## <a name="auto_config">Turning Hyperloop auto_config OFF</a>

By default, Hyperloop will automatically import all necessary files and directories.

For different reasons it can be useful to turn this functionnality OFF and manually import all needed files and directories.

#### Turn auto_config OFF

```ruby
#config/application.rb

config.hyperloop.auto_config = false
```

#### Load needed files

```ruby
#config/application.rb

###########################################
# Hyperloop config for advanced configuration
###########################################

config.hyperloop.auto_config = false

config.autoload_paths   -= %W[#{config.root}/app/hyperloop]
config.autoload_paths   += %W[#{config.root}/app/hyperloop/models]
config.autoload_paths   += %W[#{config.root}/app/models/public]
config.autoload_paths   += %W[#{config.root}/app/hyperloop/operations]
config.eager_load_paths -= %W[#{config.root}/app/hyperloop]
config.eager_load_paths += %W[#{config.root}/app/hyperloop/models]
config.eager_load_paths += %W[#{config.root}/app/models/public]
config.eager_load_paths += %W[#{config.root}/app/hyperloop/operations]
```

```ruby
#config/initializers/assets.rb

Rails.application.config.assets.paths << Rails.root.join('app', 'hyperloop').to_s
Rails.application.config.assets.paths << Rails.root.join('app', 'models').to_s

```


```
#app/assets/javascripts/application.js

//= require 'react_ujs'
//= require 'jquery'
//= require 'jquery_ujs'
//= require 'turbolinks'
//= require_tree .

//= require 'components'
Opal.load('components');
```

You create a new file : `app/hyperloop/components.rb`

```ruby
#app/hyperloop/components.rb

require 'opal'

require 'react/react-source-browser'
require 'react/react-source-server'

require 'hyper-component'

if React::IsomorphicHelpers.on_opal_client?
  require 'opal-jquery'
  require 'browser'
  require 'browser/interval'
  require 'browser/delay'
end

require 'hyper-model'
require 'hyper-store'
require 'hyper-operation'
require 'hyper-router/react-router-source'
require 'hyper-router'
require 'models'

require_tree './components'
require_tree './operations'
require_tree './stores'

```

You create a new file : `app/models/models.rb`

```
#app/hyperloop/models/models.rb

require_tree './public' if RUBY_ENGINE == 'opal'
```

You create a new directory: `app/models/public`.

In this directory you can move all you models files that can be accessible by the client.

Then finally you move the `app/models/application_record.rb` file to `app/models/public/application_record.rb`

## <a name="changingdirectories">Changing Hyperloop default directories</a>

By default the hyperloop install generator creates the hyperloop structure inside the `/app` directory :

```
/app/hyperloop/
/app/hyperloop/components
/app/hyperloop/models
/app/hyperloop/operations
/app/hyperloop/stores
```

If for any reasons you want to change those directories places you can do that using the config parameter `config.hyperloop.auto_config = false`.

You can find the complete source code of a Helloworld sample Hyperloop app using the advanced configuration parameters here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-helloworld-advancedconfig';">Hyperloop with Advanced configuration and production mode source code</button>

For example, let's say you want this architecture:

+ Components in the `app/views/components` directory
+ Models in `app/models/public` directory
+ Operations in `myhyperloop/operations` directory
+ Stores in `myhyperloop/stores` directory

#### First you have to modify some configurations files

```ruby
#config/application.rb

config.hyperloop.auto_config = false

config.eager_load_paths += %W(#{config.root}/app/models/public)
config.autoload_paths += %W(#{config.root}/app/models/public)
config.eager_load_paths += %W(#{config.root}/app/myhyperloop/operations)
config.autoload_paths += %W(#{config.root}/app/myhyperloop/operations)

config.assets.paths << ::Rails.root.join('app', 'myhyperloop').to_s
config.assets.paths << ::Rails.root.join('app', 'models').to_s
```

```
#app/assets/javascripts/application.js

//= require 'react_ujs'
//= require 'jquery'
//= require 'jquery_ujs'
//= require 'turbolinks'
//= require_tree .

//= require 'components'
//= require 'myhyperloop'
Opal.load('components');
Opal.load('myhyperloop');
```

```
#app/views/components.rb

require 'opal'

require 'react/react-source-browser'
require 'react/react-source-server'

require 'hyper-component'

if React::IsomorphicHelpers.on_opal_client?
  require 'opal-jquery'
  require 'browser'
  require 'browser/interval'
  require 'browser/delay'
end

require 'hyper-model'
require 'hyper-store'
require 'hyper-operation'
require 'models'

require_tree './components'

```

```
#app/models/models.rb

require_tree './public' if RUBY_ENGINE == 'opal'
```


#### Your Components


```
#app/views/components/home/helloworld.rb

module Components
  module Home
  	class Helloworld < Hyperloop::Component
  		...
  	end
   end
end
```

#### Your models

```
#app/models/public/helloworld.rb

class Helloworld < ApplicationRecord
end

```

```
#app/models/public/application_record.rb

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
```


#### Your operations and Stores

```
app/myhyperloop
app/myhyperloop/operations
app/nyhyperloop/stores
```

```
#app/myhyperloop/myhyperloop.rb

require_tree './operations'
require_tree './stores'
```


