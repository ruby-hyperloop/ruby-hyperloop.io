var TODO_COMPONENT = `
class TodoList < React::Component::Base

  param :items, type: [String]

  def render
    ul do
      params.items.each_with_index do |item, index|
        li(key: "item - #{index}") { item }
      end
    end
  end
end

class TodoApp < React::Component::Base

  before_mount do
    state.items! []
    state.text! ""
  end

  def render
    div do
      h3 { "TODO" }
      TodoList items: state.items
      div do
        input(value: state.text).on(:change) do |e|
          state.text! e.target.value
        end
        button { "Add ##{state.items.length+1}" }.on(:click) do |e|
          state.items! (state.items + [state.text!("")])
        end
      end
    end
  end
end

Element["#todo-target"].render { TodoApp() }
`;

React.render(
  <ReactPlayground codeText={TODO_COMPONENT} elementId="todo-target" />,
  document.getElementById('todoExample')
);
