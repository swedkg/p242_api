class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    # render json: @users, status: :ok

    
    render json: @users.map { |user|
      if(user.picture.attached?)
        user.as_json.merge({image: url_for(user.picture)})
      else 
        user.as_json.merge({image: nil})
      end
    }, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
  
    if @user.save
      render json: @user, status: :created, location: @user
    else
      puts("we are out")
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:email, :firstName, :lastName, :password, :picture)
  end

end
