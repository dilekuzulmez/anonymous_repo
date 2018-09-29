module SeasonsHelper
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show_season_custom_hash(season)
    teams_list = content_tag(:div) do
      season.teams.each do |t|
        concat content_tag(:div, link_to(t.name, team_path(t)))
      end
    end

    { teams: teams_list.html_safe }
  end

  def show_total_price(home_team_id, current_season, ticket_type_id)
    return 0 if !home_team_id.present? || !ticket_type_id.present?
    zone_id = TicketType.find(ticket_type_id).zone_id
    matches = Match.current_season_with_home_team(home_team_id, current_season)
    matches.includes(:ticket_types).where('ticket_types.zone_id = ?', zone_id).sum(:price)
  end

  def current_season(league_id = nil)
    Season.active.find_by(league_id: league_id) || Season.new
  end
end
