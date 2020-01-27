require 'test_helper'

class FullfilmentsModelTest < ActiveSupport::TestCase

  test "validate request is blank" do
    fullfilment = Fullfilment.new(request: nil)
    fullfilment.valid?
    assert fullfilment.errors.added?(:request, :blank)
    assert fullfilment.errors.added?(:request, "must exist")
  end
  
  test "validate user is blank" do
    fullfilment = Fullfilment.new(user: nil)
    fullfilment.valid?
    assert fullfilment.errors.added?(:user, :blank)
    assert fullfilment.errors.added?(:user, "must exist")
  end
  
end