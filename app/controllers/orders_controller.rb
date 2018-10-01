# rubocop:disable Metrics/ClassLength
class OrdersController < ApplicationController
  include SeasonsHelper
  before_action :authenticate_admin!
  before_action :set_order, only: %i[show edit update destroy logs]
  after_action :update_order, only: %i[create update]

  # GET /orders
  # rubocop:disable all
  def index
    @seasons = Season.active
    @q = Order.ransack(params[:q])
    @orders = @q.result.includes(:order_details, :customer)
    @orders = filter.page(page_params).order('orders.id desc')
    respond_to do |format|
      format.html do
        render :index
      end

      format.json do
        render json: @orders.to_json
      end
    end
  end

  # GET /orders/1
  def show; end

  def logs
    @logs = (@order.audits + @order.associated_audits).sort_by { |e| -e[:id] }
    @logs = Kaminari.paginate_array(@logs).page(page_params)
  end

  # GET /orders/new
  def new
    @order = Order.new
    set_view_data
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders
  def create
    @order = Order.new(order_params)
    set_view_data
    respond_to do |format|
      if create_service.execute
        format.html { redirect_to orders_path, notice: 'Order was successfully created.' }
      else
        render_create_new(format)
      end
    end
  end

  def render_create_new(format)
    order_params[:home_team_id] ? format.html { render :new_season_order } : format.html { render :new }
  end

  # PATCH/PUT /orders/1
  def update
    set_view_data

    respond_to do |format|
      if update_service.execute
        format.html { redirect_to orders_path, notice: 'Order was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
    end
  end

  private

  def import_params
    params.permit(:file, :utf8, :authenticity_token, :button)
  end

  def set_view_data
    @matches = if %w[new create].include?(action_name)
                 Match.can_sell_ticket.to_a
               else
                 @order.matches.uniq
               end
    @ticket_type_options = []
    @teams = season.teams if %w[new_season_order].include?(action_name) && season.teams.present?
    redirect_to orders_path, flash: { error: 'Please create a season include teams first.' } if %w[new_season_order].include?(action_name) && season.teams.empty?
  end

  def create_service
    @create_service ||= CreateOrderService.new(@order)
  end

  def update_service
    @update_service ||= UpdateOrderService.new(@order, order_params)
  end

  def update_order
    if @order.status.completed?
      @order.order_details.each do |detail|
        detail.update(expired_at: detail.match.start_time + 2.hours)
      end
    end
  end

  def set_order
    @order = Order.includes(order_details: [:ticket_type, :match => [:home_team, :away_team]]).find(params[:id])
  end

  def set_ticket_type_options
    @ticket_type_options = @order&.match&.ticket_types || []
  end

  def filtering_params
    @filters = params.slice(:by_customer_name, :by_phone, :by_purchased_date, :by_paid)
  end

  # /orders?by_customer_name=somename
  # /orders?by_phone=0999999999
  # /orders?by_purchased_date=[from_date,to_date]
  # /orders?by_paid=true
  def filter
    filtering_params.each do |key, value|
      @orders = @orders.public_send(key, value) if value.present?
    end
    @orders
  end

  def order_params
    params.fetch(:order, {}).permit(
      :home_team_id, :total_price, :customer_id, :shipping_address, :promotion_code,
      :purchased_date, :paid, :status, 
      order_details_attributes: %i[id ticket_type_id quantity unit_price match_id _destroy]
    )
  end
end
