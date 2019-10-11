class FullfilmentsController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  before_action :set_fullfilment, only: [:destroy]

  # GET /fullfilments
  # GET /fullfilments.json

#   render json: @riders.map { |rider|
#   rider.as_json.merge({image: url_for(rider.picture)})
# }, status: :ok

  def index
    puts params
    if params[:user_id]
      puts("are we here?")
      @fullfilments = Fullfilment.where(user_id: params[:user_id])
      
      # Message.where(:sender_id=>1, :receiver_id=>2, :fullfilment_id=>6).or(Message.where(:sender_id=>2, :receiver_id=>1, :fullfilment_id=>6)).order(:created_at)
    else
      puts("or here?")
      @fullfilment = Fullfilment.all
    end
        render json: @fullfilments.map { |f|
        @request_title = f.request.title
        @request_desc = f.request.desc
        @requester_id= f.request.owner_id
        @messages = Message.where(:sender_id=>f.user_id, :receiver_id=>@requester_id, :fullfilment_id=>f.id)
                .or(Message.where(:sender_id=>@requester_id, :receiver_id=>f.user_id, :fullfilment_id=>f.id))
                .order(:created_at)
        puts(@messages.count)
        puts(f.id)
        puts("------------------------")
        f.as_json.merge({
          request: {
            title: @request_title,
            desc: @request_desc,
            owner: @requester_id,
          },
          messages: @messages
         })
        } , status: :ok
  end

  # GET /fullfilments/1
  # GET /fullfilments/1.json
  def show
    @fullfilment = Fullfilment.where(id: params[:id])
    if @fullfilment.exists?
      render json: @fullfilment, status: :ok
    else
      render json: {status: "error", message: "Can't find fullfilment"}, status: :unprocessable_entity
    end
  end

  # GET /fullfilments/new
  def new
    @fullfilment = Fullfilment.new
  end

  # GET /fullfilments/1/edit
  def edit
  end

  # POST /fullfilments
  # POST /fullfilments.json
  def create
    puts("we are here")

    @fullfilment = Fullfilment.new(fullfilment_params)

    if @fullfilment.save

      # TODO: to be moved to background task
        # @fullfilment_id = @fullfilment.id
        # @sender_id=fullfilment_params[:user_id]
        # @sender = User.find(@sender_id)
        # @request_id=fullfilment_params[:request_id]
        # @request=Request.find(@request_id)
        # @receiver_id=@request[:owner_id]
        @sender = @fullfilment.user
        @request = @fullfilment.request
        @receiver = @fullfilment.request.owner
        @message= "Hello " + @receiver.firstName + ", there is a volunteer! " + @sender.firstName + " " + @sender.lastName + " has signed up to fulfill your request"
        puts(fullfilment_params.to_json, @sender_id, @sender.to_json,@request.to_json, @request[:id], @message)

        m = Message.new(:fullfilment => @fullfilment, :sender => @sender, :receiver => @receiver, :message => @message)
        m.save
        if m.save
          render json: @fullfilment, status: :created
        else
          render json: {status: "error", message: "Can't create message"}, status: :unprocessable_entity  
        end
      else
        render json: @fullfilment.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /fullfilments/1
  # PATCH/PUT /fullfilments/1.json
  def update
    @fullfilment = Fullfilment.where(id: params[:id])
    if @fullfilment.exists?
      @fullfilment.update(fullfilment_params)
      render json: @fullfilment, status: :created, location: @fullfilment
    else
      render json: {status: "error", message: "Can't find fullfilment"}, status: :unprocessable_entity
    end
  end

  # DELETE /fullfilments/1
  # DELETE /fullfilments/1.json
  def destroy
    @fullfilment.destroy
    respond_to do |format|
      format.html { redirect_to fullfilments_url, notice: 'Fullfilment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fullfilment
      @fullfilment = Fullfilment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fullfilment_params
      params.permit(:request_id, :user_id, :status)
    end
end
