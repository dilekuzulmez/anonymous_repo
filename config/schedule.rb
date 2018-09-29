env :PATH, ENV['PATH']
RAILS_ROOT = `pwd`

every 1.hour do
  runner "ServerMonitorService.new.execute"
end

every 30.minutes do
  command "cd #{RAILS_ROOT} ; . server.sh"
end
