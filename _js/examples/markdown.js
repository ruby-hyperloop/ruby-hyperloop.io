var MARKDOWN_COMPONENT = `
class MarkdownEditor < React::Component::Base

  before_mount { state.value! "Type some *markdown* here" }

  def raw_markup
    { __html: %x{marked(#{state.value}, {sanitize: true})}}
  end

  render do
    div.MarkdownEditor do
      h3 { "Input" }
      textarea(defaultValue: state.value).on(:change) do |e|
        state.value! e.target.value
      end
      h3 { "Output" }
      div.content(dangerously_set_inner_HTML: raw_markup)
    end
  end
end

Element["#markdown-target"].render { MarkdownEditor() }
`;

ReactDOM.render(
  <ReactPlayground codeText={MARKDOWN_COMPONENT} elementId="markdown-target"/>,
  document.getElementById('markdownExample')
);
