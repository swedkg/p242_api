class SessionsController < ApplicationController
  before_action :authenticate_user! , except: [:create]

  def create
    user = User.where(email: params[:email]).first

    if user&.valid_password?(params[:password])
      if(user.picture.attached?)
        image = url_for(user.picture)
      else
        image = nil
      end
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

  def destroy   
  end
  
  def logout     

    current_user.authentication_token = nil
    if (current_user.save!)
      render json: {message: "User logged out" }, status: :ok
    end
  end
  
end