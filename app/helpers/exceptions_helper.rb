module ExceptionsHelper
  def render_error(message, status = 400)
    render json: { error: { message: message } }, status: status
  end

  def render_error_with_code(message, code = 0, status = 400)
    render json: { error: { message: message, code: code } }, status: status
  end

  def render_result(data, status = 200)
    render json: data, status: status
  end

  def render_result_purchase(status)
    render file: Rails.public_path.join('purchase', 'success.html') if status == 'success'
    render file: Rails.public_path.join('purchase', 'failure.html') if status == 'failure'
  end

  def render_500(exception)
    Rails.logger.error("[API] class=#{exception.class} message=#{exception.message}")

    render_error('Internal Server Error', 500)
  end

  def record_not_found
    render json: { error: 'Record Not Found' }.to_json, status: 404
  end
end
