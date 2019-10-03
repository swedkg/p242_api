class FullfilmentsController < ApplicationController
  # before_action :authenticate_user! , except: [:index]
  before_action :set_fullfilment, only: [:destroy]

  # GET /fullfilments
  # GET /fullfilments.json
  def index
    puts params
    if params[:request_id]
      puts("are we here?")
      @fullfilment = Fullfilment.where(request_id: params[:request_id])
    else
      puts("or here?")
      @fullfilment = Fullfilment.all
    end
    render json: @fullfilment, status: :ok
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
        render json: @fullfilment, status: :created, location: @fullfilment
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
