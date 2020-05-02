class MessagingChannel < ApplicationCable::Channel
  require 'json'

  def subscribed
  puts('subscribed to MessagingChannel')
  stream_for(current_user, coder: ActiveSupport::JSON)
  end

  def message_delivered(data)
    puts "------------------- delivered !!!! -------------------"
    d =  OpenStruct.new(data)
    message_id = d.message
    # puts data
    # puts d
    # puts message_id
    m=Message.find(message_id)
    # puts m.as_json
    status = m.status
    # puts status
    # if (status = 0)
    #   m.update(status: 1)
    # else
    
    # if (status = 0)
        m.update(status: 1)
    #   elsif (status = 1)
    #     m.update(status: 2)
    # end

    # puts m.as_json
    
    # notify the original sender
    # that the message was delivered
    @sender = User.find(m.sender_id)
    # @receiver = User.find(m.receiver_id)
    # puts @sender.as_json
    # puts current_user.as_json

    # we should do something similar here, there is no point for reconstrucint the message
    MessagingChannel.broadcast_to(@sender, body: {message_id: m.id}, type: "message_delivered")

    # pubMessage = m.as_json().merge({
    #   fullfilment_status: m.fullfilment.status,
    #   users: {
    #     sender: {
    #       id: @sender.id,
    #       firstName: @sender.firstName,
    #       lastName: @sender.lastName,
    #       },
    #     receiver: {
    #       id: @receiver.id,
    #       firstName: @receiver.firstName,
    #       lastName: @receiver.lastName,
    #       }
    #     },
    #   request_id: m.fullfilment.request_id
    #   })

    # puts pubMessage.as_json

    # MessagingChannel.broadcast_to(@sender, body: pubMessage, type: "message")

    puts "-----------------------------------------------------"
  end

  def message_displayed(data)
    puts "------------------- message displayed !!!! -------------------"
    d =  OpenStruct.new(data)
    message_id = d.message
    # puts data
    # puts d
    # puts message_id
    m=Message.find(message_id)
    # puts m.as_json
    status = m.status

    m.update(status: 2)
    
    @sender = User.find(m.sender_id)

    # puts @sender.as_json
    # puts current_user.as_json

    
    MessagingChannel.broadcast_to(@sender, body: {message_id: m.id}, type: "message_displayed")

    puts "-----------------------------------------------------"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end