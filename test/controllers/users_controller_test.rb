require 'test_helper'

  # TODO: lock routes
  # TODO: test that locked routes cannot be accessed

class UsersControllerTest < ActionDispatch::IntegrationTest
  # users_url= "/users"

  test "create user" do
    post users_path,
    params: {
      firstName: "jane",
      lastName: "Doe",
      password: "password",
      email: "jane.doe@example.com",
    }

    assert_equal 201, @response.status
  end

end

def json_response
  ActiveSupport::JSON.decode @response.body
end
