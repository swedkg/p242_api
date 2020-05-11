require 'test_helper'

class MessagingChannelTest < ActionCable::Channel::TestCase

  def test_broadcasting_on_subscribed
    assert_has_stream_for @user
  end

  def test_message_delivered
    @message=messages(:message_one)
    assert_broadcasts(@user, 1) do
      perform :message_delivered, message: @message.id
    end
  end

  def test_message_displayed
    @message=messages(:message_one)
    assert_broadcasts(@user, 1) do
      perform :message_displayed, message: @message.id
    end
  end

  private
  def setup
    @user = users(:user_one)
    stub_connection(current_user: @user)
    subscribe room: @user.authentication_token
  end
end
