# Space Launch Notifier
Receive a notification when Kennedy Space Center schedules an upcoming launch.

## Usage Examples
You can use this service by requiring the main module and extending a specific notification:

- Receive an email notification of the next launch.
  ```rb
  require_relative '../domain/space_launch_notifier' 
  require_relative '../notifications/email_notification'

  SpaceLaunchNotifier.extend(EmailNotification)
  SpaceLaunchNotifier.broadcast!(:next)

  ```

- Receive a MacOS notification of the next launch happening within three days from now.

  ```rb
  require_relative '../domain/space_launch_notifier' 
  require_relative '../notifications/macbook_notification'

  SpaceLaunchNotifier.extend(MacbookNotification)
  SpaceLaunchNotifier.broadcast!(:next) do |upcoming_events|
    three_days_from_now = DateTime.now + 3
    upcoming_events.filter { |event| event.start < three_days_from_now }
  end
  ```

## Adding a Notification Provider
Create a custom `Notification` module by creating a class.

### Requirements
Your custom notification class should accept these massages:
- `.from_event(event)`
  - Accepts an argument of an instance of `KennedySpaceCenter::Event`
  - Returns an initialized instance of `self`.
- `#fire!`
  - Accepts no arguments.
  - Return anything (for now).

### Example
```rb
module TwilioNotification
  class Notification
    attr_accessor :title, :desciption, :date

    class << self
      # Returns an instance initialized from an event.
      #
      # @param event [KennedySpaceCenter::Event] a Kennedy Space Center event.
      # @return [MacbookNotification::Notification] a new instance of this class.
      def from_event(event)
        new(
          title: 'Space Launch Imminent!',
          desciption: event.short_summary,
          date: event.start_display
        )
      end
    end

    def initialize(title:, desciption:, date:)
      # ... Configure the settings for this notification.
    end

    # Triggers the delivery of this notification synchronously.
    # Raises any error that causes a failure in the delivery.
    #
    def fire!
      # ... Send text message.
    end
  end
end
```

### More Examples
See [./scripts](https://github.com/kevinmirc/space-launch-notifier/tree/master/scripts) for more examples.
