class ChatService

  def initialize(&block)
    @block = block
    @messages = []
    @user_id = nil
    @socket = Browser::Socket.new("wss://ruby-websockets-chat.herokuapp.com/") do |socket|
      socket.on :message do |e|
        data = JSON.parse(`unescape(#{JSON.parse(e.data)[:text]})`)
        @messages << data
        @block.call [data] if id
      end
    end
  end

  def login(user_id)
    @user_id = user_id
    @block.call @messages
  end

  def id
    @user_id
  end

  def send(data = {})
    @socket.send({handle: id, text: `escape(#{data.to_json})`}.to_json)
  end

end
