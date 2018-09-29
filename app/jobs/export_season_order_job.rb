class ExportSeasonOrderJob < ApplicationJob
  def perform(season_id)
    ExportCsvService.new('Season').export_order_by_season(season_id)
  end
end
