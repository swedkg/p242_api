require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  requests_url = '/requests'

  setup do
    @request = requests(:request_one)
  end

  test "should get index" do

    get requests_url

    # puts json_response

    assert_response :success

  end

  test "should create request" do

    user = users(:user_one)

    assert_difference('Request.count') do
      post requests_url, params: { desc: @request.desc, title: @request.title, owner_id: user['id'] }, headers: { 'X-User-Email' => user['email'], 'X-User-Token' => user['authentication_token'] }
      # puts json_response
    end

    assert_response 201
  end

  # test "shoud get platform status" do
    
  #   get '/platform/status'

  #   assert_response 200
  #   assert json_response['requests']['total']
  #   assert json_response['requests']['unfulfilled']
  #   assert json_response['requests']['time']

  # end


end



def json_response
  ActiveSupport::JSON.decode @response.body
end

