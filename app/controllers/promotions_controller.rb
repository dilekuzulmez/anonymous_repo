class PromotionsController < ApplicationController
  before_action :set_promotion, only: %i[show edit update destroy]

  # GET /promotions
  # GET /promotions.json
  def index
    @promotions = Promotion.all.page(page_params)
  end

  def find
    @promotion = Promotion.find_by_code(params)

    if @promotion
      render json: @promotion.to_json
    else
      head 400
    end
  end

  # GET /promotions/1
  # GET /promotions/1.json
  def show; end

  # GET /promotions/new
  def new
    @promotion = Promotion.new
  end

  # GET /promotions/1/edit
  def edit; end

  # POST /promotions
  def create
    @promotion = Promotion.new(promotion_params)

    respond_to do |format|
      if @promotion.save
        format.html { redirect_to promotions_path, notice: 'Promotion was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /promotions/1
  def update
    respond_to do |format|
      if @promotion.update(promotion_params)
        format.html { redirect_to promotions_path, notice: 'Promotion was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /promotions/1
  def destroy
    @promotion.destroy
    respond_to do |format|
      format.html { redirect_to promotions_url, notice: 'Promotion was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_promotion
    @promotion = Promotion.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def promotion_params
    params.fetch(:promotion, {}).permit(
      :code, :discount_type, :discount_amount, :active, :description,
      :quantity, :limit_number_used, :start_date, :end_date, ticket_types: [], match_ids: []
    )
  end
end
