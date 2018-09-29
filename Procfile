# 1st: Exec rails server 
# 2st: start side kiq
# 3st: migrate database

web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: bundle exec sidekiq -c 5 -v
release: rake db:migrate
