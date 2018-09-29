def seed_stadium_zones(stadium)
  all_zones = [
    {code: 'Standard 1', capacity: 50, price: 100000, zone_type: 0},
    {code: 'Standard 2', capacity: 50, price: 150000, zone_type: 0},
    {code: 'Premium 1', capacity: 100, price: 200000, zone_type: 1},
    {code: 'Premium 2', capacity: 100, price: 250000, zone_type: 1},
    {code: 'VIP A', capacity: 200, price: 300000, zone_type: 2},
    {code: 'VIP B', capacity: 200, price: 350000, zone_type: 2},
  ]

  all_zones.each do |zone|
    attrs = zone.merge(stadium_id: stadium.id)
    Zone.where(stadium_id: stadium.id, code: zone[:code]).first_or_create!(attrs)
  end
end

# HNB
hnb_name = 'Chelsea'
hnb = Team.where(name: hnb_name).first_or_create(name: hnb_name, code: 'CHE', description: "Chelsea Football Club is a professional football club in London, England, that competes in the Premier League. Founded in 1905, the club's home ground since then has been Stamford Bridge. Chelsea won the First Division title in 1955, followed by various cup competitions between 1965 and 1971.")

hnb_stdum = Stadium.where(team_id: hnb.id).first_or_create(name: 'Stamford Bridge', address: 'London', team_id: hnb.id)
seed_stadium_zones(hnb_stdum)

# TLW
tlw_name = 'Manchester United'
tlw = Team.where(name: tlw_name).first_or_create(name: tlw_name, code: 'MU', description: "Manchester United Football Club, commonly known as Man. United or simply United, is a professional football club based in Old Trafford, Greater Manchester, England, that competes in the Premier League, the top flight of English football.")

tlw_stdum = Stadium.where(team_id: tlw.id).first_or_create(name: 'Old Traffold', address: 'Manchester, England', team_id: tlw.id)
seed_stadium_zones(tlw_stdum)

# DND
dnd_name = 'Liverpool'
dnd = Team.where(name: dnd_name).first_or_create(name: dnd_name, code: 'LIV', description: "Liverpool Football Club is a professional football club in Liverpool, England, that competes in the Premier League, the top tier of English football.")

dnd_stdum = Stadium.where(team_id: dnd.id).first_or_create(name: 'Anfield', address: 'England', team_id: dnd.id)
seed_stadium_zones(dnd_stdum)

# SGH
sgh_name = 'Tottenham Hotspur'
sgh = Team.where(name: sgh_name).first_or_create(name: sgh_name, code: 'TOT', description: "Tottenham Hotspur Football Club, commonly referred to as Tottenham or Spurs, is a professional football club in Tottenham, London, England, that competes in the Premier League. The club's home ground for the 2018–19 season is Tottenham Hotspur Stadium, with the first few home games of the season at Wembley Stadium. ")

sgh_stdum = Stadium.where(team_id: sgh.id).first_or_create(name: 'Wembley', address: 'England', team_id: sgh.id)
seed_stadium_zones(sgh_stdum)

Promotion.where(code: 'LIVERPOOL10').first_or_create(code: 'LIVERPOOL10', discount_type: 'percent', discount_amount: '10', description: 'Buy 3 -> 5 tickets', active: true, start_date: Date.today, end_date: Date.today + 1.month)
Promotion.where(code: 'CHELSEA20').first_or_create(code: 'CHELSEA20', discount_type: 'percent', discount_amount: '20', description: 'Buy 6 -> 10 tickets', active: true, start_date: Date.today, end_date: Date.today + 1.month)
Admin.create(email: 'diepsohung@gmail.com')
Customer.create(email: 'diepsohung@gmail.com')
