class RequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_request, only: [:update, :destroy]
  # after_action :app_status 

  # GET /requests
  def index
    if params[:request_id]
      @requests = Request.where(id: params[:request_id])
    else
      @requests = Request.where(fulfilled: false)
    end
    
    render json: @requests.map { |r|
      # @user_ids = m.fullfilments.pluck(:user_id)
      @collection = r.responders
        .pluck(:user_id, :firstName, :lastName)
  
      @details = @collection.map{
        |user_id, firstName, lastName|
        {
          id: user_id,
          firstName: firstName,
          lastName: lastName,
          fullfilment: r.responders.find(user_id).fullfilments.select{ |f| f.request.id == r.id}.last
        }
      }

      @user_ids = @details.map{ |user| user[:id] }

      numOfResponders = @user_ids.length

      set_request_status(r, numOfResponders)

      r.as_json(except: [:created_at, :updated_at]).merge({
        responders: {
          ids: @user_ids,
          details: @details
        }
      })
    }

  end

  # GET /requests/1
  def show
    @request = Request.where(id: params[:id])
    if @request.exists?
      render json: @request, status: :ok
    else
      render json: {status: "error", message: "Can't find request"}, status: :unprocessable_entity
    end
  end

  # POST /requests
  def create
    # render json: {status: "created"},status: :created
    @request = Request.new(request_params)
    if @request.save

      pubRequest = Request.where(id: @request.id).map { |r|
        # @user_ids = m.fullfilments.pluck(:user_id)
        @collection = r.responders
        .pluck(:user_id, :firstName, :lastName)
        
        @details = @collection.map{
          |user_id, firstName, lastName|
          {
            id: user_id,
            firstName: firstName,
            lastName: lastName,
            fullfilment: r.responders.find(user_id).fullfilments.select{ |f| f.request.id == r.id}.last
          }
        }
        
        @user_ids = @details.map{ |user| user[:id] }          
        numOfResponders = @user_ids.length
        
        r.as_json(except: [:created_at, :updated_at]).merge({
          updated_at: r.updated_at,
          responders: {
            ids: @user_ids,
            details: @details
          }
          })
        }
        
        pubRequest = pubRequest[0]
        
      # broadcast the request to all users
      ActionCable.server.broadcast "platform_status_channel", body: pubRequest, type: "request"

      render json: @request, status: :created, location: @request
    else
      # puts("we are out")
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      render json: @request, status: :ok
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def request_params
      params.except(:request).permit(:title, :desc, :owner_id, :lat, :lng, :id, :isOneTime, :fulfilled, :address, :republished)
    end
end
