class ChatService

  def initialize(&block)
    @block = block
    time = Time.now
    @messages = [
        {from: "user1", time: (time-10.days).to_i,    message: "A 2 point message: \n+ point 1\n+ point 2\nGot it?"},
        {from: "user2", time: (time-8.days).to_i,     message: "message sent 8 days ago, by user 2"},
        {from: "user3", time: (time-5.days).to_i,     message: "message sent in the last week"},
        {from: "user2", time: (time-4.days).to_i,     message: "message sent **also** in the last week"},
        {from: "user1", time: (time-1.hour).to_i,     message: "Was sent within the last hour!"},
        {from: "user2", time: (time-30.minutes).to_i, message: "Was sent 30 minutes ago"},
        {from: "user3", time: (time-10.minutes).to_i, message: "Was just sent\n\n\n\n\n\n\n\n\nwith a lot of blanks"},
        {from: "user1", time: Time.now.to_i,          message: "just now"}
      ]
  end

  def login(user_name)
    @user_name = user_name
    @block.call @messages
  end

  def id
    @user_name
  end

  def send(data = {})
    @messages << data
    @block.call [data]
  end

end
