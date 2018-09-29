module OrderImportHelper
  # :name, :address, :contact, :team_id, :seatmap
  def stadium_from_csv(row)
    Stadium.where(name: row[:stadium]).first_or_create(name: row[:stadium])
  rescue StandardError => _
    nil
  end

  # TODO: import dynamic is_season and limit_number_used from csv
  def promo_from_csv(row)
    code = row[:discount_code]
    return nil if code.nil?
    Promotion.where(code: code, discount_amount: row[:discount_rate].to_f)
             .first_or_create(code: code,
                              active: true,
                              discount_amount: row[:discount_rate].to_f,
                              is_season: false,
                              limit_number_used: 1, start_date: Date.current, end_date: Date.current)
  rescue StandardError => _
    nil
  end

  def home_team_from_row(row)
    name = row[:home_team]
    Team.where(name: name)
        .first_or_create(name: name)
  rescue StandardError => _
    nil
  end

  def away_team_from_row(row)
    name = row[:away_team]
    Team.where(name: name)
        .first_or_create(name: name)
  rescue StandardError => _
    nil
  end

  def customer_from_csv(row)
    Customer.where(email: row[:email])
            .first_or_create!(email: row[:email], point: user_point(row),
                              first_name: row[:first_name],
                              last_name: row[:last_name],
                              phone_number: row[:phone_number],
                              gender: (row[:gender]&.downcase),
                              address: address(row),
                              birthday: dob_from_row(row))
  rescue StandardError => _
    nil
  end

  def dob_from_row(row)
    (Date.parse(row[:dob]) unless row[:dob].nil?)
  end

  def user_point(row)
    (row[:user_point].nil? ? 0 : row[:user_point].to_i)
  end

  # :code, :quantity, :price, :benefit
  def ticket_type_from_csv(zone, match)
    TicketType.where(code: zone.code)
              .first_or_create(
                zone: zone,
                code: zone.code,
                price: zone.price,
                quantity: zone.capacity,
                match_id: match&.id
              )
  rescue StandardError => _
    nil
  end

  def address(row)
    { city: row[:city], district: row[:district] } unless row[:city].nil? && row[:city].nil?
  end

  def commission_rate(row)
    (row[:commission_rate].to_f / 100 unless row[:commission_rate].nil?)
  end

  # :stadium_id, :code, :description, :price, :capacity
  def zone_from_csv(row, stadium)
    seat = row[:seat]
    Zone.where(code: seat)
        .first_or_create(stadium_id: stadium.id, code: seat, price: row[:ticket_price], capacity: 1_000_000)
  rescue StandardError => _
    nil
  end

  def match_from_csv(row, stadium)
    Match.where(stadium_id: stadium.id, name: row[:name_of_match], start_time: row[:start_time])
         .first_or_create!(
           stadium_id: stadium.id,
           start_time: row[:start_time],
           name: row[:name_of_match],
           home_team: home_team_from_row(row),
           away_team: away_team_from_row(row)
         )
  rescue StandardError => _
    nil
  end
end
