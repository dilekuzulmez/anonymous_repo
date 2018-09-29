class AddAttachmentSeatmapToStadiums < ActiveRecord::Migration[5.1]
  def self.up
    change_table :stadiums do |t|
      t.attachment :seatmap
    end
  end

  def self.down
    remove_attachment :stadiums, :seatmap
  end
end
