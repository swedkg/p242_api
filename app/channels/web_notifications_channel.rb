# class WebNotificationsChannel < ApplicationCable::Channel
#   def subscribed
#   puts('subscribed')
#     stream_from "web_notifications_channel"
#   end
  

#   def unsubscribed
#     # Any cleanup needed when channel is unsubscribed
#   end
# end

class WebNotificationsChannel < ApplicationCable::Channel
  def subscribed
    puts "web_notifications_channel"
    authentication_token = current_user.authentication_token
    puts authentication_token
    stream_from "web_notifications_channel_#{params[:room]}"
    ActionCable.server.broadcast "web_notifications_channel_#{params[:room]}", message: current_user
    puts "---------------"

  end
  
  # rebroadcast a message sent by one client to any other connected clients.
  #   def received(data)
  #     puts(data)
  #     ActionCable.server.broadcast 'web_notifications_channel', message: data
  #   end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end


