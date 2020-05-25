class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, fallback: :none

    #                                                          icons
    #     republished     users     hide from map      fulfill       republish
    #       0 (def)        <5             N                Y             N
    #       1              5>=            Y                Y             N
    #       2              <5             Y                Y             Y (if not fufilled after 24h)

    # send (?) WS message after every change of status
    # do others know that this request changed status?

  def set_request_status (request,numOfResponders)
    # TODO: remember to correct
    responders_limit = 3
    ts_24h=DateTime.now.ago(24*3600)
    ts_60s=DateTime.now.ago(60)
    time_shift=request.created_at < ts_60s

    case request.republished
    when 0
      # we reach the number of responders
      if (numOfResponders == responders_limit) 
        Request.find(request.id).update(republished: 1)
        request.republished = 1
      end
    when 1
      # one of the responders was removed
      if (numOfResponders < responders_limit)
        r = Request.find(request.id)
        r.update(republished: 2)
        request.republished = 2

        if (request.allow_republish_at.nil?)
          # TODO: remember to adjust time
          # DateTime.now + 24.hours
          r.update(allow_republish_at: DateTime.now + 20.seconds)
          request.allow_republish_at = DateTime.now + 20.seconds  
        end
      end
    when 2
      if (numOfResponders == responders_limit)
        Request.find(request.id).update(republished: 1, allow_republish_at: nil)
        request.republished = 1
        request.allow_republish_at = nil
      end
    end

  end

  def app_status
    requests= Request.all
    online_users=User.where(online: true).count
    # unfulfilled=[]
    # requestsAll= Request.all.count
    # unfulfilled= Request.where(:status =>false).count

    unfulfilled=requests.select do |elem|
      elem.fulfilled == false
    end
    time = Time.new
    # puts current_user.as_json
    ActionCable.server.broadcast "platform_status_channel", body: {platform_status: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}}, online_users: online_users, type: "status"
  end

end
