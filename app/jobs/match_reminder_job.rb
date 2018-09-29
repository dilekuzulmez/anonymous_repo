class MatchReminderJob < ApplicationJob
  queue_as :default

  def perform(match)
    title = match.name
    content = "Trận đấu giữa #{match.name} sẽ bắt đầu sau 5 tiếng nữa !"
    NotificationsService.new.send_notifications(title, content)
  end
end
