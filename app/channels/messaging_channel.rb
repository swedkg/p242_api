class MessagingChannel < ApplicationCable::Channel
  def subscribed
  puts('subscribed to MessagingChannel')
  stream_for(current_user, coder: ActiveSupport::JSON)
  end
  

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end