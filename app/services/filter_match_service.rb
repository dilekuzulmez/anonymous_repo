class FilterMatchService
  # rubocop:disable Metrics/AbcSize
  def execute(filters)
    if filters[:type].to_i == Match::UPCOMING_MATCH
      timeline = filters[:from_time].present? ? filters[:from_time].to_time : Time.current
      matches = Match.filter_upcoming_from(timeline).active.order('start_time ASC')
      matches = matches.filter_upcoming_to(filters[:to_time].to_time) if filters[:to_time].present?
      matches = matches.filter_by_teams(filters[:teams]) if filters[:teams].present?
      matches = matches.filter_by_venues(filters[:venues]) if filters[:venues].present?
    else
      matches = Match.active.played.order('start_time DESC')
    end

    matches
  end
end
