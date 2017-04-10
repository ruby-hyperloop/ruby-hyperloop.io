class ChatService

  def initialize(&block)
    @block = block
    @messages = {"from"=>"user1", "time"=>1449089985, "message"=>"A 2 point message: \n+ point 1\n+ point 2\nGot it?"},{"from"=>"user2", "time"=>1449262785, "message"=>"message sent 8 days ago, by user 2"},{"from"=>"user3", "time"=>1449521985, "message"=>"message sent in the last week"},{"from"=>"user2", "time"=>1449608385, "message"=>"message sent **also** in the last week"},{"from"=>"user1", "time"=>1449950385, "message"=>"Was sent within the last hour!"},{"from"=>"user2", "time"=>1449952185, "message"=>"Was sent 30 minutes ago"},{"from"=>"user3", "time"=>1449953385, "message"=>"Was just sent\n\n\n\n\n\n\n\n\nwith a lot of blanks"},{"from"=>"user1", "time"=>1449953985, "message"=>"just now"}
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