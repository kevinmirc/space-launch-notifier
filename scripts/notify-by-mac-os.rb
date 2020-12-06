# Desktop notification on Mackbook Pro for the next launch within 3 days from now

require_relative '../domain/space_launch_notifier' 
require_relative '../notifications/macbook_notification'

SpaceLaunchNotifier.extend(MacbookNotification)
SpaceLaunchNotifier.broadcast!(:next) do |upcoming_events|
  three_days_from_now = DateTime.now + 3
  upcoming_events.filter { |event| event.start < three_days_from_now }
end
