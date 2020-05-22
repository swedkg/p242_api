# class WebNotificationsChannel < ApplicationCable::Channel
#   def subscribed
#   puts('subscribed')
#     stream_from "web_notifications_channel"
#   end
  
 
#   def unsubscribed
#     # Any cleanup needed when channel is unsubscribed
#   end
# end

class PlatformStatusChannel < ApplicationCable::Channel
  def subscribed
    puts "-- PlatformStatusChannel subscribed --"
    # stream_for(current_user, coder: ActiveSupport::JSON)
    current_user.online = true
    current_user.save!
    stream_from "platform_status_channel"
    app_status
    # ActionCable.server.broadcast "web_notifications_channel_#{params[:room]}", message: current_user
    # ActionCable.server.broadcast "web_notifications_channel", {requests: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}, online_users: online_users}
    # puts "-- - --"

  end
  
  # rebroadcast a message sent by one client to all other connected clients.
    def public_announcement(data)
      # puts "-- public announcement !!!! --"
      # puts(data)
      os =  OpenStruct.new(data)
      request_id = os.message['id']
      type = os.message['type']
      request = Request.find(request_id)
      
      if type == "request_fulfilled"
        request.update(fulfilled: true)
        ActionCable.server.broadcast "platform_status_channel", request: {id: request_id, fulfilled: true}, type: type
      end
      
      if type == "request_republished"
        request.update(republished: 0, allow_republish_at: nil)
        ActionCable.server.broadcast "platform_status_channel", request: {id: request_id, allow_republish_at: nil}, type: type
      end

      # TODO: republish
      app_status
      # puts "-- - --"
      # ActionCable.server.broadcast 'web_notifications_channel_#{params[:room]}', message: data
    end

  def unsubscribed
    puts "-- unsubscribed --"
    current_user.online = false
    current_user.save!
    app_status
    # puts "-- - --"
    # Any cleanup needed when channel is unsubscribed
  end

  private
  def app_status
    requests= Request.all
    online_users=User.where(online: true).count

    unfulfilled=requests.select do |elem|
      elem.fulfilled == false
    end
    time = Time.new
    # PlatformStatusChannel.broadcast_to(current_user, requests: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}, online_users: online_users)
    ActionCable.server.broadcast "platform_status_channel", body: {platform_status: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}}, online_users: online_users, type: "status"
  end
end


