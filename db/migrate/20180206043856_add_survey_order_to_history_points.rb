class AddSurveyOrderToHistoryPoints < ActiveRecord::Migration[5.1]
  def change
    add_reference :history_points, :survey, foreign_key: true, index: true
    add_reference :history_points, :order, foreign_key: true, index: true
  end
end
