var HELLO_COMPONENT = `
class HelloWorld

  include React::Component

  required_param :visitor

  def render
    "Hello there #{visitor}"
  end

end

React.render(React.create_element(HelloWorld, {visitor: "world"}), Element['#hello-target'])
`;

React.render(
  <ReactPlayground codeText={HELLO_COMPONENT} elementId="hello-target" />,
  document.getElementById('helloExample')
);
