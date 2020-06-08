module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # puts "-- connect to channel--"
        self.current_user = find_verified_user
      
    end
    
    private
    def find_verified_user
      query_string = request.headers['QUERY_STRING']
      authentication_token = query_string.remove("room=")
      user = User.where(authentication_token: authentication_token)
      if verified_user = User.find_by(authentication_token: authentication_token)
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
