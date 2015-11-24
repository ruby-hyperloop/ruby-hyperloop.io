"use strict";

var MARKDOWN_COMPONENT = "\nclass MarkdownEditor\n\n  include React::Component\n\n  define_state value: \"Type some *markdown* here\"\n\n  def raw_markup\n    { __html: %x{marked(#{value}, {sanitize: true})}}\n  end\n\n  def render\n    div.MarkdownEditor do\n      h3 { \"Input\" }\n      textarea(defaultValue: value).on(:change) do |e|\n        value! e.target.value\n      end\n      h3 { \"Output\" }\n      div.content(dangerously_set_inner_HTML: raw_markup)\n    end\n  end\nend\n\nReact.render(React.create_element(MarkdownEditor),Element[\"#markdown-target\"])\n";

React.render(React.createElement(ReactPlayground, { codeText: MARKDOWN_COMPONENT, elementId: "markdown-target" }), document.getElementById('markdownExample'));