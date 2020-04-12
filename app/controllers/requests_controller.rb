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
    
    # .where(:republised => [1,2])


    # Handled by back end
    # fulfilled:  false (default): display on UI
    #             true (manually set): hide from UI, disallow republish, consider it complete
    #
    # republish:  0 (default)
    #             1 (allow): responders >= 5 && alive> 24h -> display button on UI, hide from map 
    #             2 (republished) && alive> 24h -> set as fulfilled
    
    # Handled by UI
    # visible:    1 (default)
    #             0 (hidden): responders >= 5 -> hide from map


    # 

    # Request.find(1).fullfilments.pluck(:user_id)

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
          fullfilment: r.responders.find(user_id).fullfilments[0]
        }
      }

      @user_ids = @details.map{ |user| user[:id] }

      numOfResponders = @user_ids.length

      # puts(r.republished)
      time_shift_24h = r.created_at < DateTime.now.ago(24*3600)
      if (r.republished == 0) 
        if (numOfResponders >= 5)
          r.republished = 1
        end
      end

      if (r.republished == 2)
        if (r.updated_at < DateTime.now.ago(60))
          Request.find(r.id).update(fulfilled: true)
          r.fulfilled = true
        end
      end


      r.as_json.merge({
        fulfilled_at: r.updated_at < DateTime.now.ago(60),
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
