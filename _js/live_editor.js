var IS_MOBILE = (
  navigator.userAgent.match(/Android/i)
    || navigator.userAgent.match(/webOS/i)
    || navigator.userAgent.match(/iPhone/i)
    || navigator.userAgent.match(/iPad/i)
    || navigator.userAgent.match(/iPod/i)
    || navigator.userAgent.match(/BlackBerry/i)
    || navigator.userAgent.match(/Windows Phone/i)
);

var CodeMirrorEditor = React.createClass({
  propTypes: {
    lineNumbers: React.PropTypes.bool,
    onChange: React.PropTypes.func
  },
  getDefaultProps: function() {
    return {
      lineNumbers: false
    };
  },
  componentDidMount: function() {
    if (IS_MOBILE) return;

    this.editor = CodeMirror.fromTextArea(ReactDOM.findDOMNode(this.refs.editor), {
      mode: 'ruby',
      lineNumbers: this.props.lineNumbers,
      lineWrapping: true,
      smartIndent: true,  // javascript mode does bad things with jsx indents
      matchBrackets: true,
      theme: 'rubyblue',
      readOnly: this.props.readOnly
    });
    this.editor.on('change', this.handleChange);
  },

  componentDidUpdate: function() {
    if (this.props.readOnly) {
      this.editor.setValue(this.props.codeText);
    }
  },

  handleChange: function() {
    if (!this.props.readOnly) {
      this.props.onChange && this.props.onChange(this.editor.getValue());
    }
  },

  render: function() {
    // wrap in a div to fully contain CodeMirror
    var editor;

    if (IS_MOBILE) {
      editor = <pre style={{overflow: 'scroll'}}>{this.props.codeText}</pre>;
    } else {
      editor = <textarea ref="editor" defaultValue={this.props.codeText} />;
    }

    return (
      <div style={this.props.style} className={this.props.className}>
        {editor}
      </div>
    );
  }
});

var selfCleaningTimeout = {
  componentDidUpdate: function() {
    clearTimeout(this.timeoutID);
  },

  setTimeout: function() {
    clearTimeout(this.timeoutID);
    this.timeoutID = setTimeout.apply(null, arguments);
  }
};

var ReactPlayground = React.createClass({
  mixins: [selfCleaningTimeout],

  MODES: {JSX: 'JSX', JS: 'JS'}, //keyMirror({JSX: true, JS: true}),

  propTypes: {
    codeText: React.PropTypes.string.isRequired,
    elementId: React.PropTypes.string.isRequired,
    transformer: React.PropTypes.func,
    renderCode: React.PropTypes.bool,
    showCompiledJSTab: React.PropTypes.bool,
    showLineNumbers: React.PropTypes.bool,
    editorTabTitle: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      transformer: function(code) {
        var compiled_code = Opal.Opal.Compiler.$new(code).$compile();
        //result = `eval(#{compiled_code})`
        //puts "result = #{result}"
        return compiled_code;
        //return babel.transform(code).code;
      },
      editorTabTitle: 'Live Ruby Editor',
      showCompiledJSTab: true,
      showLineNumbers: false
    };
  },

  getInitialState: function() {
    return {
      mode: this.MODES.JSX,
      code: this.props.codeText,
    };
  },

  handleCodeChange: function(value) {
    this.setState({code: value});
    this.executeCode();
  },

  handleCodeModeSwitch: function(mode) {
    this.setState({mode: mode});
  },

  compileCode: function() {
    return this.props.transformer(this.state.code);
  },

  render: function() {
    var isJS = this.state.mode === this.MODES.JS;
    var compiledCode = '';
    try {
      compiledCode = this.compileCode();
    } catch (err) {}

    var JSContent =
      <CodeMirrorEditor
        key="js"
        className="playgroundStage CodeMirror-readonly"
        onChange={this.handleCodeChange}
        codeText={compiledCode}
        readOnly={true}
        lineNumbers={this.props.showLineNumbers}
      />;

    var JSXContent =
      <CodeMirrorEditor
        key="jsx"
        onChange={this.handleCodeChange}
        className="playgroundStage"
        codeText={this.state.code}
        lineNumbers={this.props.showLineNumbers}
      />;

    var JSXTabClassName =
      'playground-tab' + (isJS ? '' : ' playground-tab-active');
    var JSTabClassName =
      'playground-tab' + (isJS ? ' playground-tab-active' : '');

    var JSTab =
      <div
        className={JSTabClassName}
        onClick={this.handleCodeModeSwitch.bind(this, this.MODES.JS)}>
          Compiled JS
      </div>;

    var JSXTab =
      <div
        className={JSXTabClassName}
        onClick={this.handleCodeModeSwitch.bind(this, this.MODES.JSX)}>
          {this.props.editorTabTitle}
      </div>

    return (
      <div className="playground">
        <div>
          {JSXTab}
          <div className="playground-tab playground-tab-active target-tab" >
            <div>{this.props.elementId}</div>
          </div>
        </div>
        <div className="playgroundCode">
          {JSXContent}
        </div>
        <div className="playgroundPreview">
          <div ref="mount" id={this.props.elementId} />
        </div>
      </div>
    );
  },

  componentDidMount: function() {
    this.executeCode();
  },

  componentDidUpdate: function(prevProps, prevState) {
    // execute code only when the state's not being updated by switching tab
    // this avoids re-displaying the error, which comes after a certain delay
    if (this.props.transformer !== prevProps.transformer ||
        this.state.code !== prevState.code) {
      this.executeCode();
    }
  },

  executeCode: function() {
    var mountNode = ReactDOM.findDOMNode(this.refs.mount);
    Opal.Object.$$proto.$mount_node = function() {return mountNode;}
    try {
      React.unmountComponentAtNode(mountNode);
    } catch (e) { }

    try {
      var compiledCode = this.compileCode();
      if (this.props.renderCode) {
        React.render(
          <CodeMirrorEditor codeText={compiledCode} readOnly={true} />,
          mountNode
        );
      } else {
        eval(compiledCode);
      }
    } catch (err) {
      this.setTimeout(function() {
        React.render(
          <div className="playgroundError">{err.toString()}</div>,
          mountNode
        );
      }, 500);
    }
  }
});
