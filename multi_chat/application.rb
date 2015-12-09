class MultiChat
  def initialize(key, master_id, &block)
    @block = block
    @chats = []
    reformat_and_call_block = lambda do |native_data_array|
      block.call native_data_array.collect { |item| Hash.new(item) }
    end
    %x{
      #{@peer} = new Peer({key: #{key}, debug: 0})
      #{@peer}.on('error', function (err) {
        #{@id} = "Master"
        reformat_and_call_block([])
        #{@connections} = []
        #{@peer} = new Peer(#{master_id}, {key: #{key}, debug: 0})
        #{@peer}.on('connection', function (new_conn) {
          setTimeout(function() {
            new_conn.send(JSON.stringify(#{@chats}))
          }, 2000);
          #{@connections}.push(new_conn);
          new_conn.on('data', function (data) {
            data = JSON.parse(data)
            reformat_and_call_block(data)
            self["$_send"](data, new_conn)
          })
        })
      });
      master = #{@peer}.connect(#{master_id});
      master.on('data', function(data) {
        reformat_and_call_block(JSON.parse(data))
      })
      #{@connections} = [master]
    }
  end

  def send(data = {})
    @block.call [data]
    _send([data.to_n], nil)
  end

  def _send(data, originator)
    @chats += data
    @connections.each do | connection |
      `connection.send(JSON.stringify(data))` if `connection != originator`
    end
  end

  def id
    @id ||= `#{@peer}.id`
  end
end
