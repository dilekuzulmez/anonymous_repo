module StadiumsHelper
  def show_stadium_custom_hash(stadium)
    link = guard_link(stadium.home_team, 'N/A') { link_to stadium.home_team_name, team_path(stadium.home_team) }
    {
      home_team: link
    }
  end
end
