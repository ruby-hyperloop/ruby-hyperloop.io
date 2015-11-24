var TODO_COMPONENT = `
class TodoList

  include React::Component

  required_param :items, type: [String]

  def render
    ul do
      items.each_with_index do |item, index|
        li(key: "item - #{index}") { item }
      end
    end
  end
end

class TodoApp

  include React::Component

  define_state items: [], text: ""

  def render
    div do
      h3 { "TODO" }
      TodoList items: items
      div do
        input(value: text).on(:change) do |e|
          text! e.target.value
        end
        button { "Add ##{items.length+1}" }.on(:click) do |e|
          items! (items + [text!("")])
        end
      end
    end
  end
end

React.render(React.create_element(TodoApp), Element["#todo-target"])
`;

React.render(
  <ReactPlayground codeText={TODO_COMPONENT} elementId="todo-target" />,
  document.getElementById('todoExample')
);
