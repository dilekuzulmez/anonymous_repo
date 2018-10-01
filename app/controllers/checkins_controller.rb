class CheckinsController < ApplicationController
  before_action :authenticate_admin!

  def new; end
  def check_in
    return unless params[:checkin].dig(:match).present? && params[:checkin].dig(:code).present?
    match_id = params[:checkin].dig(:match)
    hash_key = params[:checkin].dig(:code)
    @detail = OrderDetail.find_by(match_id: match_id, hash_key: hash_key)
    return unless @detail.order.paid
    if @detail.update_attributes(expired_at: Time.current, is_qr_used: true)
      flash[:success] = "Scan successfully !"
      redirect_to checkin_new_path
    else
      flash[:danger] = "Errors !"
      redirect_to checkin_new_path
    end
  end

  def check_qr_code
    match_id = params[:match_id]
    hash_key = params[:hash_key]
    @detail = OrderDetail.find_by(match_id: match_id, hash_key: hash_key)
    render json: 'Invalid QR Code', status: 422 unless @detail.present?
    render json: 'This QR Code is used', status: 422 if @detail.present? && @detail.is_qr_used && @detail.expired_at < Time.now
  end
end
