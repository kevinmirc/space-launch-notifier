module MacbookNotification
  class Notification
    attr_accessor :title, :desciption, :date

    class << self
      def from_event(event)
        new(
          title: 'Space Launch Imminent!',
          desciption: event.short_summary,
          date: event.start_display
        )
      end
    end

    def initialize(title:, desciption:, date:)
      @title = title
      @desciption = desciption
      @date = date
    end

    def fire!
      # TODO: ! escape the two layers of string interpolation (tried Shellwords but throws errors about unexpected token when expecting a ")
      # 
      `/usr/bin/osascript -e 'display notification "#{desciption}" with title "#{title}" subtitle "#{date}"'`
    end
  end
end
