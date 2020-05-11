require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  messages_url = '/messages'

  test "should get user messages" do

    user = users(:user_two).as_json

    get messages_url, params: { user_id: user['id'] }, headers: { 'X-User-Email' => user['email'], 'X-User-Token' => user['authentication_token'] }

    # puts json_response
    
    assert_response :success
    
  end
  
  test "should create message" do
    
    sender = users(:user_one).as_json
    receiver = users(:user_two).as_json
    request = requests(:request_one).as_json
    fullfilment = fullfilments(:fullfilment_one).as_json    
    
    assert_difference('Message.count') do
    post messages_url, params: { sender_id: sender['id'], receiver_id: receiver['id'], fullfilment_id: fullfilment['id'], message: 'Should create message' }, headers: { 'X-User-Email' => sender['email'], 'X-User-Token' => sender['authentication_token'] }
    end  

    assert_response 201
    
  end

end



def json_response
  ActiveSupport::JSON.decode @response.body
end

