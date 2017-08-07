---
title: Tutorials, Videos & Quickstarts
---


We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.

During this tutorial we will learn how to use Hyperloop <a href="/docs/components/dsl-overview" class="component-blue"><b>C</b>omponents</a>, <a href="/docs/stores/overview" class="store-green"><b>S</b>tores</a> and <a href="/docs/operations/overview" class="operation-purple"><b>O</b>perations</a>. 

We will also see also how the <a href="/docs/models/configuring-transport" class="policies-black"><b>P</b>ush notifications</a> works. So every chatters will se all messages updated in realtime in their browser.  

<img src="/images/tutorials/HyperloopJS-Chatapp.gif" class="imgborder">


You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-chatapp';">Hyperloop with Rails ChatApp Source code</button>

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the <br><br>
<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/installation#rorsetup';">Hyperloop installation with Ruby On Rails tutorial</button>

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
      DIV do
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

todo

You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-chatapp';">Hyperloop with Rails ChatApp Source code</button>


<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>