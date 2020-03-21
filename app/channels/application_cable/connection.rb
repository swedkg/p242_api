module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      puts "------- connect -----------"
        self.current_user = find_verified_user
      puts "---------------------------"
      
    end
    
    private
    def find_verified_user
      puts "------- find_verified_user -----------"
      # (?<==)[a-zA-Z\d]
      query_string = request.headers['QUERY_STRING']
      # authentication_token = query_string.scan(/(?<==)[a-zA-Z\d]/).join()
      authentication_token = query_string.remove("authentication_token=")
      user = User.where(authentication_token: authentication_token)
      puts query_string
      puts authentication_token
      puts user.as_json
      # request.headers.each { |key, value| puts "#{key}: #{value}" }
      # puts cookies.to_hash
      # request.headers["Cookie"]
      # request.headers["HTTP_COOKIE"]
      # puts cookies.fetch("X-Authorization")
      puts "---------------------------"
      if verified_user = User.find_by(authentication_token: authentication_token)
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end

  # class Connection < ActionCable::Connection::Base
  #   # identified_by :current_user
    
  #   def connect
  #     self.current_user = find_verified_user_from_cookies
  #   end

  #   private
  #   def find_verified_user_from_cookies
      
  #     current_user = User.find_by_id(cookies.signed[:user_id])

  #     if current_user
  #       current_user
  #       puts "---------"
  #       puts current_user.as_json
  #       puts "---------"
  #     else
  #       reject_unauthorized_connection
  #       puts "connection refused"
  #     end
  #   end
  # end


# end