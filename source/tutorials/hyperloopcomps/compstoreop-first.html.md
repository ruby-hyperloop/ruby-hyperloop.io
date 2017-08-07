---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">F</span>irst simple app using Components, Stores <br>and Operations Tutorial

<img src="/images/tutorials/Hyperloop-Compsimple.gif" class="imgborder">

The code below implements few examples using Hyperloop **Components** which wrap React, **Stores** to hold state which is shared between **Components** and an **Operation** for mutating the **Store**'s state. Finally, a Clock which demonstrates local state and a callback which triggers every second.

To set up your **Hyperloop** environment and continue this tutorial, please first follow the <br><br>
<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/installation';">Hyperloop installation tutorial</button>

After **Hyperloop** has been installed properly we can go further.

```ruby

class TopLevelComponent < Hyperloop::Component
    render(DIV) do
      DIV(class: 'container') do
        H1 { "Components, Stores and Operations" }
        P { "A few examples using Hyperloop Components which wrap React, Stores to hold state which is shared between Components and an Operation for mutating the Store's state. Finally, a Clock which demonstrates local state and a callback which triggers every second." }
        TypeAlong()
        Buttons()
        Clock()
        StylishTable()
      end
    end
  end

  class Buttons < Hyperloop::Component
    render(DIV) do
      H2 { "Some buttons" }
      BUTTON(class: 'btn btn-primary') { 'See the value' }.on(:click) { alert "MyStore value is '#{ MyStore.value }'" }
      BUTTON(class: 'btn btn-link') { 'Clear' }.on(:click) { ClearOp.run }
    end
  end

  class TypeAlong < Hyperloop::Component
    render(DIV) do
      H2 { "MyStore value is '#{ MyStore.value }'" }
      INPUT(type: :text, value: MyStore.value ).on(:change) do |e|
        MyStore.set_value e.target.value
      end
    end
  end

  class Clock < Hyperloop::Component
    param format: '%a, %e %b %Y %H:%M:%S'
    before_mount do
      mutate.time Time.now.strftime(params.format)
      every(1) { mutate.time Time.now.strftime(params.format) }
    end
    render(DIV) do
      H2 { "And a clock" }
      "The time is #{state.time}"
    end
  end

  class MyStore < Hyperloop::Store
    state :value, reader: true, scope: :class
    def self.set_value value
      mutate.value value
    end
    def self.clear
      mutate.value ""
    end
  end

  class ClearOp < Hyperloop::Operation
    step { puts "about to clear everything" }
    step { MyStore.clear }
  end

  class StylishTable < Hyperloop::Component
  render(DIV) do
  H2 { "A stylish table" }
    TABLE(class: 'table table_bordered') do
      THEAD do
        TR do
          TH { "First Name" }
          TH { "Last Name" }
          TH { "Username" }
        end
      end
      tbody do
        TR do
          TD { "Mark" }
          TD { "Otto" }
          TD(class: 'text_success') { MyStore.value }
        end
      end
    end
  end
end

```



<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>