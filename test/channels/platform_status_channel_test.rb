# Using ActionCable::TestCase

require 'test_helper'

class PlatformStatusChannelTest < ActionCable::Channel::TestCase

  def test_subscribed

    # Asserts that the subscription was successfully created
    assert subscription.confirmed?

    # Asserts that the channel subscribes connection to a stream
    assert_has_stream "platform_status_channel"

  end

  def test_unsubscribed
    
    # Asserts that the channel subscribes connection to a stream
    assert_has_stream "platform_status_channel"    

    unsubscribe
    assert_no_streams

  end

  def test_public_announcement
   assert_broadcasts('platform_status_channel', 1) do
      ActionCable.server.broadcast 'platform_status_channel', { text: 'platform_status_channel' }
    end
  end

  private
  def setup
    stub_connection(current_user: users(:user_one))
    subscribe
  end

end