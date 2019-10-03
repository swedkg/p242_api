class RequestsController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  before_action :set_request, only: [:update, :destroy]

  # GET /requests
  def index
    @requests = Request.all

    render json: @requests
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
