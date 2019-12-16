class RequestsController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  before_action :set_request, only: [:update, :destroy]

  # GET /requests
  def index
    @requests = Request.all
    
    # .where(:republised => [1,2])


    # change respond to fulfill 

    # TODO:
    # 0 = published (displayed on the map)
    # 1 = can be republished (hidden from map, enable Republish button) -> after the 24h shift
    # 2 = republished (displayed on map) -> cannot go to status #1
    # 3 = closed (never display again)

    # default status = 0

    # TODO:
    # Once 5 separate users have clicked on the fulfillment button
    # the need is no longer displayed on the site => in Fullfilments Controller set status = 0
    
    # time_diff = time_now - created_at
    # we will filter this in in the UI

    # TODO: if responders == 5 && time_diff < 24h => status = 2    
    # calculated every time we ask for all the requests 

    # TODO: if fulfilled == true => status = 3
    
    # if rep = 0 check against the current time
    # ...
    # update status

    # 

    # Request.find(1).fullfilments.pluck(:user_id)

    render json: @requests.map { |r|
      # @user_ids = m.fullfilments.pluck(:user_id)
      @collection = r.responders
        .pluck(:user_id, :firstName, :lastName)
  
      # fullfilment_status = r.fullfilments.where(status: false)
      #   puts(fullfilment_status)
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

      r.as_json.merge({
        # time_now: DateTime.now,
        # time_shift: time_shift = DateTime.now.ago(3600),
        # compare: time_shift < r.updated_at,
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
      render json: @request, status: :ok
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
    requests= Request.all
    # unfulfilled=[]
    # requestsAll= Request.all.count
    # unfulfilled= Request.where(:status =>false).count

    unfulfilled=requests.select do |elem|
      elem.republised == 0
    end
    time = Time.new.inspect
    render json: {requests: {"total": requests.length, "unfulfilled": unfulfilled.length, "time": time}}, status: :ok
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
