require 'test_helper'

class RequestModelTest < ActiveSupport::TestCase

  test "validate description field is blank" do
    request = Request.new(desc: nil)
    request.valid?
    assert request.errors.added?(:desc, :blank)
    assert request.errors.added?(:desc, "Your description cannot be blank")
  end

  test "validate description is too short" do
    request = Request.new(desc: "ab")
    request.valid?
    assert request.errors.added?(:desc, :too_short, {count: 3})
    assert request.errors.added?(:desc, "Your description is too short.")
  end

  test "validate description is too long" do
    request = Request.new(desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sollicitudin dui ac risus varius, sit amet malesuada est volutpat. Quisque rhoncus, felis eu varius egestas, augue nisl convallis velit, at mattis felis dolor nec lacus. Sed venenatis lectus a odio accumsan, id ornare massa eleifend. Sed enim sed.")
    #Generated 1 paragraph, 48 words, 310 bytes of Lorem Ipsum

    request.valid?
    assert request.errors.added?(:desc, :too_long, {count:300})
    assert request.errors.added?(:desc, "Your description is too long (300 characters max).")
  end
  
  test "validate user must exit" do
    request = Request.new(owner: nil)
    request.valid?
    assert request.errors.added?(:owner, :blank)
    assert request.errors.added?(:owner, "can't be blank")
  end

end
