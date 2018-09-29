FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    uid { Faker::Number.number(16) }
    provider 'google_oauth2'
  end
end
