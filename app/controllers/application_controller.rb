class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, fallback: :none

  def app_status
    requests= Request.all
    # online_users=User.where("updated_at > ?", 5.minutes.ago).count
    # unfulfilled=[]
    # requestsAll= Request.all.count
    # unfulfilled= Request.where(:status =>false).count

    unfulfilled=requests.select do |elem|
      elem.fulfilled == false
    end
    time = Time.new.inspect
    # puts current_user.as_json
    ActionCable.server.broadcast "web_notifications_channel", {requests: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}}
  end

end
