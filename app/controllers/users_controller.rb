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

  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      image = url_for(@user.picture)
      render json: @user.as_json(only: [:id, :email, :authentication_token, :firstName, :lastName]).merge({image: image}), status: :created
    else
      puts("we are out")
      render json: @user.errors.as_json, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:email, :firstName, :lastName, :password, :picture)
  end

end
