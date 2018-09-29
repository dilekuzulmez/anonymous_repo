module MatchesHelper
  # rubocop:disable Metrics/AbcSize
  def show_match_custom_hash(match)
    {
      winner: guard_link(match.winner) { link_to(match.winner.name, team_path(match.winner)) },
      season: guard_link(match.season) { link_to(match.season_name, season_path(match.season)) },
      stadium: guard_link(match.stadium) { link_to(match.stadium_name, stadium_path(match.stadium)) },
      home_team: guard_link(match.home_team) { link_to(match.home_team_name, team_path(match.home_team)) },
      away_team: guard_link(match.away_team) { link_to(match.away_team_name, team_path(match.away_team)) }
    }
  end

  def active_filter_class(filter)
    # @match_filter is assign from MatchesController
    @match_filter == filter ? 'active' : ''
  end
end
