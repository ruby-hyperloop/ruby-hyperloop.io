"use strict";

var HELLO_COMPONENT = "\nclass HelloWorld\n\n  include React::Component\n\n  required_param :visitor\n\n  def render\n    \"Hello there #{visitor}\"\n  end\n\nend\n\nReact.render(React.create_element(HelloWorld, {visitor: \"world\"}), Element['#hello-target'])\n";

React.render(React.createElement(ReactPlayground, { codeText: HELLO_COMPONENT, elementId: "hello-target" }), document.getElementById('helloExample'));