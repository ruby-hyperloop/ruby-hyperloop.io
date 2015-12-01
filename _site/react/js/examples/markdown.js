"use strict";

var MARKDOWN_COMPONENT = "\nclass MarkdownEditor < React::Component::Base\n\n  before_mount { state.value! \"Type some *markdown* here\" }\n\n  def raw_markup\n    { __html: %x{marked(#{state.value}, {sanitize: true})}}\n  end\n\n  def render\n    div.MarkdownEditor do\n      h3 { \"Input\" }\n      textarea(defaultValue: state.value).on(:change) do |e|\n        state.value! e.target.value\n      end\n      h3 { \"Output\" }\n      div.content(dangerously_set_inner_HTML: raw_markup)\n    end\n  end\nend\n\nElement[\"#markdown-target\"].render { MarkdownEditor() }\n";

React.render(React.createElement(ReactPlayground, { codeText: MARKDOWN_COMPONENT, elementId: "markdown-target" }), document.getElementById('markdownExample'));