---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">C</span>hat-App Tutorial

We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.

During this tutorial we will learn how to use Hyperloop **Components**, **Operations** and **Stores**. 

We will also see also how the [**Server push notification**](/docs/models/configuring-transport) works. So every chatters will se all messages updated in realtime in their browser.  

![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-chatapp/master/hyperloopjschatappscreenshot.png)

You can find the complete source code of this tutorial here: [Hyperloop with Rails ChatApp](https://github.com/ruby-hyperloop/hyperloop-rails-chatapp)

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further:

#### Step 1: Creating the Chatapp component

Run the hyperloop generator:

```
rails g hyper:component Chatapp
```

You can view the new Component created in `/app/hyperloop/components/`

```ruby
class HomeController < ApplicationController
  def chatapp
    render_component
  end
end
```


```ruby
#config/routes.rb

root 'home#chatapp'
```




```ruby
#/app/hyperloop/components/chatapp.rb

  class Chatapp < Hyperloop::Component

    def render
      div do
        Nav()
        
      end
    end
    
  end
 ```


 ```ruby
 #/app/hyperloop/components/nav.rb

 class Nav < Hyperloop::Component

  before_mount do
    mutate.user_name_input ''
  end

  render do
    div.navbar.navbar_inverse.navbar_fixed_top do
      div.container do
        div.collapse.navbar_collapse(id: 'navbar') do
          form.navbar_form.navbar_left(role: :search) do
            div.form_group do
              input.form_control(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
              ).on(:change) do |e|
                mutate.user_name_input e.target.value
              end
              button.btn.btn_default(type: :button) { "login!" }.on(:click) do
                Operations::Join(user_name: state.user_name_input)
              end if valid_new_input?
            end
          end
        end
      end
    end
  end

  def valid_new_input?
    state.user_name_input.present? && state.user_name_input != MessageStore.user_name
  end
end
```

```ruby
#/app/hyperloop/stores/message_store.rb

class MessageStore < Hyperloop::Store
  
  state :user_name, scope: :class, reader: true

  receives Operations::Join do |params|
    puts "receiving Operations::Join(#{params})"
    mutate.user_name params.user_name
  end

 
end
```