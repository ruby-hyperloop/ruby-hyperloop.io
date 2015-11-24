"use strict";

var TIMER_COMPONENT = "\nclass Ticker\n  include React::Component\n\n  define_state ticks: 0\n\n  after_mount do\n    @timer = every(1) {ticks! ticks+1}\n  end\n\n  before_unmount do\n    @timer.stop\n  end\n\n  def render\n    div {\"Seconds Elapsed: #{ticks}\"}\n  end\n\nend\n\nReact.render(React.create_element(Ticker), Element['#timer-target'])\n";

React.render(React.createElement(ReactPlayground, { codeText: TIMER_COMPONENT, elementId: "timer-target" }), document.getElementById('timerExample'));