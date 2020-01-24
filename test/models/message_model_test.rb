require 'test_helper'

class MessageModelTest < ActiveSupport::TestCase

  test "validate message field is blank" do
    message = Message.new(message: '')
    message.valid?
    assert message.errors.added?(:message, :blank)
    assert message.errors.added?(:message, "Your message cannot be blank")
  end

  test "validate message is too short" do
    message = Message.new(message: "ab")
    message.valid?
    assert message.errors.added?(:message, :too_short, {count: 3})
    assert message.errors.added?(:message, "Your message is too short.")
  end

  test "validate message is too long" do
    message = Message.new(message: "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890333")
    message.valid?
    assert message.errors.added?(:message, :too_long, {count:150})
    assert message.errors.added?(:message, "Your message is too long (150 characters max).")
  end

end
