class WebNotificationsChannel < ApplicationCable::Channel
  # def subscribed
  # puts('subscribed')
  #   ActionCable.server.broadcast 'web_notifications_channel', message: 'subscribed'
  #   # stream_from "web_notifications_channel"
  # end
  
  # def received(data)
  #   puts(data)
  #   ActionCable.server.broadcast 'web_notifications_channel', message: data
  # end

  # def unsubscribed
  #   # Any cleanup needed when channel is unsubscribed
  # end
end
