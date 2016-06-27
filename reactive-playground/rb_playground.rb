class CodeMirrorEditor < React::Component::Base

  def mobile?
    `(navigator.userAgent.match(/Android/i) || navigator.userAgent.match(/webOS/i) || navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/iPod/i) || navigator.userAgent.match(/BlackBerry/i) || navigator.userAgent.match(/Windows Phone/i)) ? #{true} : #{false}`
  end

  param :show_line_numbers, type: Boolean
  param :readonly, type: Boolean
  param :_onEdit, type: Proc, default: nil, allow_nil: true
  param :code_text, type: String
  param :theme, type: String
  param :mode, type: String
  param :rows, type: Integer, allow_nil: true
  collect_other_params_as :attributes

  after_mount do
    return if mobile?
    code_mirror_params = {
      mode: params.mode,
      lineNumbers: params.show_line_numbers,
      lineWrapping: true,
      smartIndent: true,
      matchBrackets: true,
      theme: params.theme,
      readOnly: params.readonly
    }.to_n
    on_change = lambda { |value| params._onEdit(`value.getValue()`) }
    @editor = `CodeMirror.fromTextArea(ReactDOM.findDOMNode(#{refs[:editor].to_n}), #{code_mirror_params})`
    `#{@editor}.on('change', #{on_change})`
    `#{@editor}.setSize(null, #{@editor}.defaultTextHeight()*#{params.rows})` if params.rows.present?
  end

  after_update do
    `#{@editor}.setValue(#{params.code_text})` if params.readonly
  end

  def style
    if params.rows.present?
      {overflowY: :auto}
    else
      {}
    end
  end

  def render
    div(attributes) do
      if mobile?
        pre(style: {overflow: :scroll}) { params.code_text }
      else
        textarea(ref: :editor, defaultValue: params.code_text, style: style)
      end
    end
  end
end

class ReactRBPlayground < React::Component::Base

  param :code_text, type: String
  param :element_id, type: String
  param :show_line_numbers, type: Boolean
  param :preview_in_tab, type: Boolean
  param :rows, type: Integer, default: nil, allow_nil: true
  param :display_only

  before_mount do
    state.tab! "ruby"
    state.code! params.code_text
  end

  def switch_tabs(tab)
    state.tab! tab
  end

  def class_for(tab)
    if tab == "preview" && !params.preview_in_tab
      "playground-tab playground-tab-active target-tab"
    elsif state.tab == tab
      "playground-tab playground-tab-active"
    else
      "playground-tab"
    end
  end

  def style_for(tab)
    if state.tab == tab || (tab == "preview" && !params.preview_in_tab)
      {display: :block}
    else
      {display: :none}
    end
  end

  def preview_class
    params.preview_in_tab ? "playgroundCode playgroundTabbedPreview" : "playgroundPreview"
  end

  def title
    if params.display_only
      params.element_id
    else
      "Live Ruby Editor"
    end
  end

  def render
    div.playground do
      # tabs
      div do

        div(class: class_for(:ruby)) { title }.
        on(:click) do
          switch_tabs(:ruby)
        end

        div(class: class_for(:preview)) { params.element_id }.
        on(:click) do
          switch_tabs(:preview)
        end unless params.display_only

      end
      # edit window
      div.playgroundCode(style: style_for(:ruby)) do
        CodeMirrorEditor(
          class:             "playgroundStage",
          key:               :ruby,
          mode:              :ruby,
          code_text:         state.code,
          show_line_numbers: params.show_line_numbers,
          theme:             'rubyblue',
          rows:              params.rows,
          readonly:          params.display_only
        ).on(:edit) do | text |
          state.code! text
          execute_code
        end
      end
      # optional results preview
      div.playgroundCode(class: preview_class, style: style_for(:preview)) do
        div(ref: :mount, id: params.element_id)
      end unless params.display_only
    end
  end

  after_mount   :execute_code
  after_update  :execute_code

  def execute_code
    return if state.code == @current_executing_code || params.display_only
    @current_executing_code = state.code
    @time_out.abort if @time_out
    mount_node = `ReactDOM.findDOMNode(#{refs[:mount].to_n})`
    `ReactDOM.unmountComponentAtNode(#{mount_node})` rescue nil
    begin
      compiled_code = Opal::Compiler.new(state.code).compile
      `eval(#{compiled_code})`
    rescue Exception => e
      @time_out = after(0.5) do
        Element[mount_node].render { div.playgroundError { e.message } }
      end
    end
  end
end

Element.instance_eval do
  alias_native :insert_after, :insertAfter
  alias_native :has_class, :hasClass
end

Document.ready? do
  Element['div.ruby-code-view'].each do |ele|
    Element[ele].render do
      ReactRBPlayground(
        code_text:         ele.find('code').text.strip,
        element_id:        ele.data("example-id"),
        rows:              ele.attr('rows'),
        display_only:      ele.has_class('display-only'),
        preview_in_tab:    ele.has_class('preview-in-tab'),
        show_line_numbers: ele.has_class("line-numbers")
      )
    end
  end
end
