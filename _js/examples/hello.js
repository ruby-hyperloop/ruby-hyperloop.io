var HELLO_COMPONENT = `
class HelloWorld < React::Component::Base

  param :visitor

  def render
    "Hello there #{params.visitor}"
  end

end

Element['#hello-target'].render { HelloWorld(visitor: "world") }
`;

React.render(
  <ReactPlayground codeText={HELLO_COMPONENT} elementId="hello-target" />,
  document.getElementById('helloExample')
);
