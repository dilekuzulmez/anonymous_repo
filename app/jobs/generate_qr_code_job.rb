class GenerateQrCodeJob < ApplicationJob
  queue_as :default

  def perform(detail_id)
    detail = OrderDetail.find(detail_id)
    CreateQrCodeService.new.update_qr_image_job(detail)
  end
end
