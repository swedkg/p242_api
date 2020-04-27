# TODO:: check the guide https://guides.rubyonrails.org/active_record_callbacks.html
# TODO: use ActionCable to notify the frontend of changes in the db

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

        if (@request.fullfilments.count == 3)
          @request.update(republished: 1)
        end

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
          
        pubSender = User.find(@sender.id)
        pubReceiver = User.find(@receiver.id)
        pubRequest = pubRequest[0]
        # TODO: we need to set the type in order to be able to read
        # both messages and request in the front end
        MessagingChannel.broadcast_to(pubSender, body: pubRequest, type: "request")
        MessagingChannel.broadcast_to(pubReceiver, body: pubRequest, type: "request")

        puts "-------------------------------- pubsub --------------------------------"
        puts newMessage.as_json
        puts "--"
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

        # puts fullfilment_params.as_json
        puts pubMessage.as_json
        # puts pubSender.as_json
        # puts pubReceiver.as_json
        puts "------------------------------------------------------------------------------------------------"
        
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
    puts "< - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - >"
    fullfilment = @fullfilment
    puts fullfilment.as_json
    Message.where(fullfilment_id: fullfilment.id).delete_all
    @fullfilment.destroy
    if @fullfilment.destroy

      # brodcast request to both subscribers
      # so we can update their Store
      puts "-------------------------------- pubsub --------------------------------"

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
      # puts pubRequest.as_json
      pubRequest = pubRequest[0]
      pubSender = User.find(pubRequest["owner_id"])
      pubReceiver = User.find(fullfilment.user_id)

      puts "------------------------------------------------------------------------"
      # render json: @fullfilment, status: :ok
      render json: {fullfilment: @fullfilment, pubRequest: pubRequest, pubSender: pubSender, pubReceiver: pubReceiver }, status: :ok
      MessagingChannel.broadcast_to(pubSender, body: pubRequest, type: "request")
      MessagingChannel.broadcast_to(pubReceiver, body: pubRequest, type: "request")
      # render json: @fullfilment, status: :ok
      MessagingChannel.broadcast_to(pubSender, body: {fullfilment_id: fullfilment.id}, type: "remove_orphan_messages")
      MessagingChannel.broadcast_to(pubReceiver, body: {fullfilment_id: fullfilment.id}, type: "remove_orphan_messages")
    end
    puts "< - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - >"

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
