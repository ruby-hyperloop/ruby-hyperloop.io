---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">F</span>irst simple app using Components, Stores <br>and Operations Tutorial

The code below implements few examples using Hyperloop **Components** which wrap React, **Stores** to hold state which is shared between **Components** and an **Operation** for mutating the **Store**'s state. Finally, a Clock which demonstrates local state and a callback which triggers every second.

To set up your hyperloop environment and run this code, please first follow the [installation](/installation) tutorial.

```ruby

class TopLevelComponent < Hyperloop::Component
    render(DIV) do
      div.container do
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
    table.table.table_bordered do
      thead do
        tr do
          th { "First Name" }
          th { "Last Name" }
          th { "Username" }
        end
      end
      tbody do
        tr do
          td { "Mark" }
          td { "Otto" }
          td.text_success { MyStore.value }
        end
      end
    end
  end
end

```