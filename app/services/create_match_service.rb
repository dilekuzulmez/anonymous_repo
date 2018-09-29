class CreateMatchService
  def execute(match_attributes)
    match = Match.new(match_attributes)
    match.ticket_types = clone_ticket_types(match.stadium&.zones)

    match.skip_season_validation = true
    match.save
    match
  end

  private

  def clone_ticket_types(zones)
    return [] if zones.blank?

    zones.map do |zone|
      TicketType.new_from_zone(zone)
    end
  end
end
