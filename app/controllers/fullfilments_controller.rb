class FullfillmentsController < ApplicationController
  before_action :set_fullfillment, only: [:show, :edit, :update, :destroy]

  # GET /fullfillments
  # GET /fullfillments.json
  def index
    puts params
    if params[:r]
      @output = Fullfillment.where(request_id: params[:r])
    else
      @output = Fullfillment.all
    end
    render json: @output, status: :ok

  end

  # GET /fullfillments/1
  # GET /fullfillments/1.json
  def show
  end

  # GET /fullfillments/new
  def new
    @fullfillment = Fullfillment.new
  end

  # GET /fullfillments/1/edit
  def edit
  end

  # POST /fullfillments
  # POST /fullfillments.json
  def create
    @fullfillment = Fullfillment.new(fullfillment_params)

    respond_to do |format|
      if @fullfillment.save
        format.html { redirect_to @fullfillment, notice: 'Fullfillment was successfully created.' }
        format.json { render :show, status: :created, location: @fullfillment }
      else
        format.html { render :new }
        format.json { render json: @fullfillment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fullfillments/1
  # PATCH/PUT /fullfillments/1.json
  def update
    respond_to do |format|
      if @fullfillment.update(fullfillment_params)
        format.html { redirect_to @fullfillment, notice: 'Fullfillment was successfully updated.' }
        format.json { render :show, status: :ok, location: @fullfillment }
      else
        format.html { render :edit }
        format.json { render json: @fullfillment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fullfillments/1
  # DELETE /fullfillments/1.json
  def destroy
    @fullfillment.destroy
    respond_to do |format|
      format.html { redirect_to fullfillments_url, notice: 'Fullfillment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fullfillment
      @fullfillment = Fullfillment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fullfillment_params
      params.require(:fullfillment).permit(:request_id, :user_id, :status)
    end
end
