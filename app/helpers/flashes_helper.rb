module FlashesHelper
  def user_facing_flashes
    flash.to_hash.slice('danger', 'warning', 'info', 'success')
  end
end
