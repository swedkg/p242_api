class MessagingChannel < ApplicationCable::Channel
  require 'json'

  def subscribed
    stream_for(current_user, coder: ActiveSupport::JSON)
  end

  def message_delivered(data)
    d =  OpenStruct.new(data)
    message_id = d.message
    m=Message.find(message_id)
    status = m.status
    m.update(status: 1)
    
    # notify the original sender
    # that the message was delivered
    @sender = User.find(m.sender_id)

    MessagingChannel.broadcast_to(@sender, body: {message_id: m.id}, type: "message_delivered")

  end

  def message_displayed(data)
    d =  OpenStruct.new(data)
    message_id = d.message
    m=Message.find(message_id)
    status = m.status

    m.update(status: 2)
    
    @sender = User.find(m.sender_id)

    MessagingChannel.broadcast_to(@sender, body: {message_id: m.id}, type: "message_displayed")

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end