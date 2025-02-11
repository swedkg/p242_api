class SessionsController < ApplicationController
  # before_action :authenticate_user! , except: [:create]
  # after_action :app_status 

  # def sign_in_as(params)
  #   post "/sessions", params: { email: params[email], password: params[password], authentication_token:params[authentication_token] }
  # end

  def create
    user = User.where(email: params[:email]).first

    # puts params
    # puts user.as_json
    if user&.valid_password?(params[:password])
      if(user.picture.attached?)
        image = url_for(user.picture)
      else
        image = nil
      end
      user.update(online: true)
      render json: user.as_json(only: [:id, :email, :authentication_token, :firstName, :lastName]).merge({image: image}), status: :created
    else
      if (!user) 
        error="Email not found" 
      end     
      if (user && !user.valid_password?(params[:password])) 
        error="Incorrect password"
      end
      render json: {login_error: error }, status: :unauthorized
    end
  end

  # def destroy   
  # end
  
  def logout
   if current_user
      current_user.authentication_token = nil
      current_user.online = false
      if (current_user.save!)
        # current_user.update(online: false)
        app_status
        render json: {message: "User logged out" }, status: :ok
      end
    else
      render json: {message: "User logged out" }, status: :ok
    end
  end

end
