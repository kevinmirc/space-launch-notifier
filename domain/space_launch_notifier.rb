require_relative './kennedy_space_center'

class SpaceLaunchNotifier
  class << self
    def broadcast!(scope, conditions = {})
      upcoming_events = KennedySpaceCenter.upcoming_events

      case scope
      when :next
        selected_events = block_given? ? yield(upcoming_events) : upcoming_events
        notify_one(selected_events.first) if selected_events.any?
      when :all
        selected_events = block_given? ? yield(upcoming_events) : upcoming_events
        notify_many(selected_events) if selected_events.any?
      else
        raise ArgumentError.new("\"scope\" must be one of: [:next, :all]. The scope :#{scope} is not accepted")
      end
    end

    private

    def notify_one(event)
      notification = Notification.from_event(event)
      notification.fire!
    end

    def notify_many
    end

    def filter_with(events, conditions)
      
    end
  end
end
