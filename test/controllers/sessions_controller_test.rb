require 'test_helper'

# class SessionsControllerTest < ActionController::TestCase
class SessionsControllerTest < ActionDispatch::IntegrationTest

  # include Devise::Test::ControllerHelpers


  test "login user" do 
    
    file = fixture_file_upload(Rails.root.join("/files", "profile_pic_1.jpg"), "image/jpg")
    user = users(:one)
    user.picture.attach(io: File.open(file), filename: "profile_pic_1.jpg", content_type: "image/jpg")
    
    post "/sessions",
    params: {
      email: "test@example.com",
      password: "password",
    }

    user = {
      email: "test@example.com",
      password: "password",
    }

    setup { sign_in_as user }

    # assert_response 201
    assert_equal("John", json_response["firstName"])
    assert_equal("Doe", json_response["lastName"])
    assert_equal("test@example.com", json_response["email"])
    assert_equal("WwLpZe7ZYxKaZWD9Y-3Z", json_response["authentication_token"])
    assert_not_nil(json_response["image"])
    
  end

  test "logout user" do
    
    delete "/user/logout", headers: { 'X-User-Email' => 'test@example.com', 'X-User-Token' => 'WwLpZe7ZYxKaZWD9Y-3Z' }
    assert_response 200

  end

  # def current_user
  #   @current_user
  # end
  
  # setup do
  #   @current_user = users(:one)
  #   current_user = users(:one)
  # end


end


def json_response
  ActiveSupport::JSON.decode @response.body
end
