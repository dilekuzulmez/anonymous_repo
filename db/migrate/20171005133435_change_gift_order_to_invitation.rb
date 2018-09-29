class ChangeGiftOrderToInvitation < ActiveRecord::Migration[5.1]
  def up
    Order.where(kind: 'gift').update_all(kind: 'invitation')
  end

  def down
    Order.where(kind: 'invitation').update_all(kind: 'gift')
  end
end
