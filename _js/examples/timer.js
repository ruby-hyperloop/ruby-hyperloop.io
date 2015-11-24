var TIMER_COMPONENT = `
class Ticker
  include React::Component

  define_state ticks: 0

  after_mount do
    @timer = every(1) {ticks! ticks+1}
  end

  before_unmount do
    @timer.stop
  end

  def render
    div {"Seconds Elapsed: #{ticks}"}
  end

end

React.render(React.create_element(Ticker), Element['#timer-target'])
`;

React.render(
  <ReactPlayground codeText={TIMER_COMPONENT} elementId="timer-target" />,
  document.getElementById('timerExample')
);
