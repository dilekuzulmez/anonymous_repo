class ApplicationController < ActionController::Base
  include ExceptionsHelper
  include SearchHelper
  include ApiHelper
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::InvalidForeignKey, with: :deny_delete
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::UnpermittedParameters, with: -> { render_error('invalid_params') }
  before_action :authenticate_admin!, only: [:home]

  # rubocop:disable all

  def home
    @customer_count = Customer.count ; @match_count = Match.count
    @order_count = Order.count ; @promotion_count = Promotion.count
  end

  private

  def page_params
    params[:page].to_i
  end

  def deny_delete
    render json: { error: 'can not delete' }.to_json, status: 404
  end
end
