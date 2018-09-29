module TicketTypesHelper
  def show_ticket_type_custom_hash(ticket_type)
    {
      match: link_to('View Match', match_path(ticket_type.match)),
      available_ticket: ticket_type.match.remaining_seats_of_type(ticket_type.code)
    }
  end
end
