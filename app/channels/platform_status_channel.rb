class PlatformStatusChannel < ApplicationCable::Channel
  def subscribed
    puts "-- PlatformStatusChannel subscribed --"
    current_user.online = true
    current_user.save!
    stream_from "platform_status_channel"
    app_status

  end
  
  # rebroadcast a message sent by one client to all other connected clients.
    def public_announcement(data)
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

      app_status
    end

  def unsubscribed
    puts "-- unsubscribed --"
    current_user.online = false
    current_user.save!
    app_status
  end

  private
  def app_status
    requests= Request.all
    online_users=User.where(online: true).count

    unfulfilled=requests.select do |elem|
      elem.fulfilled == false
    end
    time = Time.new
    ActionCable.server.broadcast "platform_status_channel", body: {platform_status: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}}, online_users: online_users, type: "status"
  end
end


