class MessagesController < ApplicationController
  before_action :set_message, only: [:edit, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @message = Message.all
    render json: @message, status: :ok
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
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
      params.except(:newMessage).permit(:id, :message, :fullfilment_id, :sender_id, :receiver_id)
    end
end
