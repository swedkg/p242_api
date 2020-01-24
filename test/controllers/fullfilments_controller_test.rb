require 'test_helper'

class FullfilmentsControllerTest < ActionDispatch::IntegrationTest

  fullfilments_url = '/fullfilments'
  
  test "get fullfilments index" do 
    
    user = users(:two).as_json

    get fullfilments_url, params: { user_id: user['id'] }, headers: { 'X-User-Email' => user['email'], 'X-User-Token' => user['authentication_token'] }

    # puts json_response

    assert_response 200
    
  end

  test "should create fullfilments" do

    user = users(:two)
    request = requests(:request_one)

    assert_difference('Fullfilment.count') do
      assert_difference('Message.count') do
        post fullfilments_url, params: { request_id: request['id'], user_id: user['id'] }, headers: { 'X-User-Email' => user['email'], 'X-User-Token' => user['authentication_token'] }
      end  
    end

    assert_response 201
    
  end

end


def json_response
  ActiveSupport::JSON.decode @response.body
end
