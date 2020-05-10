# Using ActionCable::TestCase

require 'test_helper'

class PlatformStatusChannelTest < ActionCable::Channel::TestCase

  def test_broadcasts
    # Check the number of messages broadcasted to the stream
    assert_broadcasts 'messages', 0
    ActionCable.server.broadcast 'messages', { text: 'hello' }
    assert_broadcasts 'messages', 1

    # Check the number of messages broadcasted to the stream within a block
    assert_broadcasts('messages', 1) do
      ActionCable.server.broadcast 'messages', { text: 'hello' }
    end

    # Check that no broadcasts has been made
    assert_no_broadcasts('messages') do
      ActionCable.server.broadcast 'another_stream', { text: 'hello' }
    end
  end

  def test_subscribed

    stub_connection(current_user: users(:one))

    subscribe

    # Asserts that the subscription was successfully created
    assert subscription.confirmed?

    # Asserts that the channel subscribes connection to a stream
    assert_has_stream "platform_status_channel"

  end

  def test_unsubscribed

    stub_connection(current_user: users(:one))
    subscribe
    
    # Asserts that the channel subscribes connection to a stream
    assert_has_stream "platform_status_channel"    

    unsubscribe
    assert_no_streams

  end

end