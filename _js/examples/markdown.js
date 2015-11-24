var MARKDOWN_COMPONENT = `
class MarkdownEditor

  include React::Component

  define_state value: "Type some *markdown* here"

  def raw_markup
    { __html: %x{marked(#{value}, {sanitize: true})}}
  end

  def render
    div.MarkdownEditor do
      h3 { "Input" }
      textarea(defaultValue: value).on(:change) do |e|
        value! e.target.value
      end
      h3 { "Output" }
      div.content(dangerously_set_inner_HTML: raw_markup)
    end
  end
end

React.render(React.create_element(MarkdownEditor),Element["#markdown-target"])
`;

React.render(
  <ReactPlayground codeText={MARKDOWN_COMPONENT} elementId="markdown-target"/>,
  document.getElementById('markdownExample')
);
