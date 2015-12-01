"use strict";

var HELLO_COMPONENT = "\nclass HelloWorld < React::Component::Base\n\n  param :visitor\n\n  def render\n    \"Hello there #{params.visitor}\"\n  end\n\nend\n\nElement['#hello-target'].render { HelloWorld(visitor: \"world\") }\n";

React.render(React.createElement(ReactPlayground, { codeText: HELLO_COMPONENT, elementId: "hello-target" }), document.getElementById('helloExample'));