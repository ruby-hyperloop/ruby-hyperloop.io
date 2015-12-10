class MultiChat
  
  def initialize(key, master_id, debug = 0, &block)
    @block = block
    @chats = []
    reformat_and_call_block = lambda do |native_data_array|
      block.call native_data_array.collect { |item| Hash.new(item) }
    end
    %x{
      var logger = function(message) {
        if (debug > 1) console.log("MultiChat: "+message);
      }
      logger("creating new slave peer");
      #{@peer} = new Peer({key: #{key}, debug: #{debug}});
      logger("slave peer created");
      #{@peer}.on('error', function (err) {
        logger("error while connecting to Master, initializing as Master");
        #{@id} = "Master";
        reformat_and_call_block([]);
        logger("yielded empty message array to block");
        #{@connections} = [];
        logger("creating master peer");
        #{@peer} = new Peer(#{master_id}, {key: #{key}, debug: #{debug}});
        logger("master peer created");
        #{@peer}.on('connection', function (new_conn) {
          logger("new connection to master, sending current chats");
          setTimeout(function() {
            new_conn.send(JSON.stringify(#{@chats}));
            logger("new connection to master, current chats sent");
          }, 2000);
          #{@connections}.push(new_conn);
          new_conn.on('data', function (data) {
            logger("received data from a slave");
            data = JSON.parse(data);
            logger("parsed slave data");
            reformat_and_call_block(data);
            logger("yielded slave data to block, sending data to other slaves");
            self["$_send"](data, new_conn);
            logger("data sent to other slaves");
          })
        })
      });
      master = #{@peer}.connect(#{master_id});
      logger("connection to master created");
      master.on('data', function(data) {
        logger("data received from master");
        reformat_and_call_block(JSON.parse(data));
        logger("data from master reported to application");
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
