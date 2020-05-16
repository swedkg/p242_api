require 'test_helper'

  # TODO: lock routes
  # TODO: test that locked routes cannot be accessed

class UsersControllerTest < ActionDispatch::IntegrationTest
  # users_url= "/users"

  test "create user" do

    post users_path,
    params: {
      firstName: "Jon",
      lastName: "Doe",
      password: "password",
      email: "createUser@example.com",
      picture: fixture_file_upload(Rails.root.join("/files", "profile_pic_1.jpg"), "image/jpg")
    }

    assert_equal 201, @response.status
  end

end

def json_response
  ActiveSupport::JSON.decode @response.body
end
