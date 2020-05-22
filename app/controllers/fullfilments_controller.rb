# check the guide https://guides.rubyonrails.org/active_record_callbacks.html

class FullfilmentsController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  # before_action :authenticate_user!
  before_action :set_fullfilment, only: [:destroy]
  # after_action :app_status 

  # GET /fullfilments
  # GET /fullfilments.json
  def index
    # puts params
    if params[:user_id]
      # puts("are we here?")
      @fullfilments = Fullfilment.where(user_id: params[:user_id])
      
      # Message.where(:sender_id=>1, :receiver_id=>2, :fullfilment_id=>6).or(Message.where(:sender_id=>2, :receiver_id=>1, :fullfilment_id=>6)).order(:created_at)
      render json: @fullfilments.map { |f|
      @request_title = f.request.title
      @request_desc = f.request.desc
      @requester_id= f.request.owner_id
      @messages = Message.where(:sender_id=>f.user_id, :receiver_id=>@requester_id, :fullfilment_id=>f.id)
              .or(Message.where(:sender_id=>@requester_id, :receiver_id=>f.user_id, :fullfilment_id=>f.id))
              .order(:created_at)
      f.as_json.merge({
        request: {
          title: @request_title,
          desc: @request_desc,
          owner: @requester_id,
        },
        messages: @messages
       })
      } , status: :ok
    else
      # puts("or here?")
      @fullfilment = Fullfilment.all
      render json: @fullfilment, status: :ok
    end
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

    @fullfilment = Fullfilment.new(fullfilment_params)

    if @fullfilment.save

        @sender = @fullfilment.user
        @request = @fullfilment.request

        @receiver = @fullfilment.request.owner

        @message= "Hello " + @receiver.firstName + ", there is a volunteer! " + @sender.firstName + " " + @sender.lastName + " has signed up to fulfill your request"
        
        newMessage = Message.new(:fullfilment => @fullfilment, :sender => @sender, :receiver => @receiver, :message => @message)
        newMessage.save
        
        
        if newMessage.save
          render json: @fullfilment, status: :created

        # brodcast request to both subscribers
        # so we can update their Store
        # MessagingChannel.broadcast_to(receiver, message: pubMessage)
        
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
          set_request_status(r, numOfResponders)
          
          r.as_json(except: [:created_at, :updated_at]).merge({
            responders: {
              ids: @user_ids,
              details: @details
            }
            })
          }
          
          pubRequest = pubRequest[0]
          
        # broadcast the request to all users
        ActionCable.server.broadcast "platform_status_channel", body: pubRequest, type: "request"
        
        # send first message to both parties  
        pubSender = User.find(@sender.id)
        pubReceiver = User.find(@receiver.id)
        pubMessage = newMessage.as_json().merge({
          fullfilment_status: true,
          request_id: @request.id,
          users: {
            sender: {
              id: @sender.id,
              firstName: pubSender.firstName,
              lastName: pubSender.lastName,
              },
            receiver: {
              id: @receiver.id,
              firstName: pubReceiver.firstName,
              lastName: pubReceiver.lastName,
              }
            }
          })
        
        MessagingChannel.broadcast_to(pubSender, body: pubMessage.as_json(), type: "message")
        MessagingChannel.broadcast_to(pubReceiver, body: pubMessage.as_json(), type: "message")
        
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
    # puts(params)
    @fullfilment = Fullfilment.where(id: params[:id])
    if @fullfilment.exists?
      @fullfilment.update(fullfilment_params)
    else
      render json: {status: "error", message: "Can't find fullfilment"}, status: :unprocessable_entity
    end
  end

  # DELETE /fullfilments/1
  # DELETE /fullfilments/1.json
  def destroy
    # puts "< - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - >"
    fullfilment = @fullfilment
    # puts fullfilment.as_json
    Message.where(fullfilment_id: fullfilment.id).delete_all
    @fullfilment.destroy
    if @fullfilment.destroy

      # brodcast request to both subscribers
      # so we can update their Store
      # puts "-------------------------------- pubsub --------------------------------"

      pubRequest = Request.where(id: fullfilment.request_id).map { |r|
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
      # puts pubRequest.as_json
      pubRequest = pubRequest[0]
      pubSender = User.find(pubRequest["owner_id"])
      pubReceiver = User.find(fullfilment.user_id)

      # puts "------------------------------------------------------------------------"
      # render json: @fullfilment, status: :ok
      render json: @fullfilment, status: :ok
      # MessagingChannel.broadcast_to(pubSender, body: pubRequest, type: "request")
      # MessagingChannel.broadcast_to(pubReceiver, body: pubRequest, type: "request")
      
      # broadcast to all users
      ActionCable.server.broadcast "platform_status_channel", body: pubRequest, type: "request"

      # render json: @fullfilment, status: :ok
      MessagingChannel.broadcast_to(pubSender, body: {fullfilment_id: fullfilment.id}, type: "remove_orphan_messages")
      MessagingChannel.broadcast_to(pubReceiver, body: {fullfilment_id: fullfilment.id}, type: "remove_orphan_messages")
    end
    # puts "< - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - >"

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fullfilment
      @fullfilment = Fullfilment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fullfilment_params
      params.permit(:request_id, :user_id, :status, :id, :fullfilment)
    end

end
