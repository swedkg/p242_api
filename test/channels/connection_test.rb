require 'test_helper'
module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase

    def test_connect_with_headers_and_query_string

      user_token = 'WwLpZe7ZYxKaZWD9Y-3Z'
      connect "/cable?room=" + user_token, headers: { "QUERY_STRING" =>  user_token }
    
      assert_equal connection.current_user.authentication_token, user_token
    end

    def test_does_not_connect_with_invalidated_token

      user_token = 'invalidated_token'
      
      assert_reject_connection do
        connect "/cable?room=" + user_token, headers: { "QUERY_STRING" =>  user_token }
      end
    end

    def test_does_not_connect_without_token

      user_token = ''
      
      assert_reject_connection do
        connect "/cable?room=" + user_token
      end
    end

  end
end