require 'test_helper'

  # TODO: lock routes
  # TODO: test that locked routes cannot be accessed

class UsersControllerTest < ActionDispatch::IntegrationTest
  # users_url= "/users"

  test "create user" do
    file = fixture_file_upload(Rails.root.join("/files", "profile_pic_1.jpg"), "image/jpg").to_s

    puts file


    # TODO: pic attachment not working

    post users_path,
    params: {
      firstName: "Jon",
      lastName: "Doe",
      password: "password",
      email: "createUser@example.com",
      picture: file
    }

    puts json_response

    assert_equal 201, @response.status
  end

end

def json_response
  ActiveSupport::JSON.decode @response.body
end
