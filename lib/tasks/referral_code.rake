namespace :referral do
  desc 'Create referral code'

  task create: :environment do
    customers = Customer.all
    puts "There are #{customers.size} customers"
    count_referral_code_created = 0
    customers.each do |customer|
      next if customer.referral_code
      next unless customer.first_name || customer.last_name

      customer.create_referral_code
      customer.save

      count_referral_code_created += 1
    end
    puts "There are #{count_referral_code_created} referral code created"
  end
end
