class MessagesController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  before_action :authenticate_user!
  before_action :set_message, only: [:edit, :destroy]
  # after_action :app_status 

  # GET /messages
  # GET /messages.json
  def index
    if params[:user_id]
      user_id = params[:user_id]
      @message = Message.where(:sender_id=>user_id)
      .or(Message.where(:receiver_id=>user_id))
      .order(:created_at)
      # .group(:fullfilment_id).count
      puts @message
    else
      @message = Message.all
    end
    render json: @message.map { |m|
    @sender = User.find(m.sender_id)
    @receiver = User.find(m.receiver_id)
    m.as_json.merge({
      fullfilment_id: m.fullfilment.id,
      fullfilment_status: m.fullfilment.status,
      request_id: m.fullfilment.request.id,
      users: {
        sender: {
          id: @sender.id,
          firstName: @sender.firstName,
          lastName: @sender.lastName,
          },
        receiver: {
          id: @receiver.id,
          firstName: @receiver.firstName,
          lastName: @receiver.lastName,
          }
        }
      })
    }, status: :ok
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    puts params
    @message = Message.where(id: params[:id])
    if @message.exists?
      render json: @message, status: :ok
    else
      render json: {status: "error", message: "Can't find message"}, status: :unprocessable_entity
    end
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    # puts("It is nice to see you")
    # render json: {status: "It is nice to see you"}, status: :ok
    @message = Message.new(message_params)
    if @message.save
      room = User.find(@message.receiver_id).authentication_token
      receiver = User.find(@message.receiver_id)
      puts "--------- create ------------"
      puts @message.as_json
      puts room
      # ActionCable.server.broadcast("web_notifications_channel", room: room, message: @message.as_json)
      
      # send message to specific subscriber
      MessagingChannel.broadcast_to(receiver, room: room, message: @message.as_json)
      
      puts "---------------------"
      # ActionCable.server.broadcast "web_notifications_channel:"+room, message: @message.as_json
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    @message = Message.where(id: params[:id])
    if @message.exists?
      puts("Are we here?")
      @message.update(message_params)
      render json: @message, status: :created
    else
      render json: {status: "error", message: "Can't find message"}, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.except(:newMessage).permit(:id, :message, :fullfilment_id, :sender_id, :receiver_id , :user_id)
    end
end
