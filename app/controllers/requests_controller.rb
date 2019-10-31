class RequestsController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  before_action :set_request, only: [:update, :destroy]

  # GET /requests
  def index
    @requests = Request.all

    # Request.find(1).fullfilments.pluck(:user_id)

    render json: @requests.map { |m|
      # @user_ids = m.fullfilments.pluck(:user_id)
      @collection = m.responders
        .pluck(:user_id, :firstName, :lastName)
        # puts(@collection)
        
       @details = @collection.map{
          |user_id, firstName, lastName|
          {
            id: user_id,
            firstName: firstName,
            lastName: lastName,
          }
        }

        @user_ids = @details.map{ |user| user[:id] }

      m.as_json.merge({
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
    puts("we are here")
    puts(request_params)
    # render json: {status: "created"},status: :created
    @request = Request.new(request_params)
    
    if @request.save
      render json: @request, status: :created, location: @request
    else
      puts("we are out")
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      render json: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
  end

  # GET /requests/status
  def status
    requestsAll= Request.all.count
    unfulfilled= Request.where(:status =>false).count

    render json: {requests: {"total": requestsAll, "unfulfilled": unfulfilled}}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def request_params
      params.except(:request).permit(:title, :desc, :owner_id, :lat, :lng, :id, :isOneTime, :status, :address)
    end
end
