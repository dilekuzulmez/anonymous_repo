class SetupSidekidScheduleWorker
  include Sidekiq::Worker

  def perform
    Match.upcoming.each do |match|
      setup_match_remind match
    end
  end

  def setup_match_remind(match)
    Order.where(match_id: match.id, paid: false).each :send_push
  end
end
