"use strict";

var TIMER_COMPONENT = "\nclass Ticker < React::Component::Base\n\n  before_mount do\n    state.ticks! 0\n    @timer = every(1) {state.ticks! state.ticks+1}\n  end\n\n  before_unmount do\n    @timer.stop\n  end\n\n  def render\n    div {\"Seconds Elapsed: #{state.ticks}\"}\n  end\n\nend\n\nElement['#timer-target'].render { Ticker() }\n";

ReactDOM.render(React.createElement(ReactPlayground, { codeText: TIMER_COMPONENT, elementId: "timer-target" }), document.getElementById('timerExample'));