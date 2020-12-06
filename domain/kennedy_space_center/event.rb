require 'time'

class KennedySpaceCenter
  class Event
    attr_accessor :title, :short_summary, :location, :url, :start, :end

    def self.from_raw(raw_event, uri)
      host_uri = "#{uri.scheme}://#{uri.host}"

      url = (raw_event['url'].nil? || raw_event['url'].empty?) ? nil : host_uri + raw_event['url']
      start_datetime = (raw_event['start'].nil? || raw_event['start'].empty?) ? nil : Time.parse(raw_event['start']).to_datetime
      end_datetime = (raw_event['end'].nil? || raw_event['end'].empty?) ? nil : Time.parse(raw_event['end']).to_datetime

      new(
        title: raw_event['title'],
        short_summary: raw_event['eventShortSummary'],
        location: raw_event['location'],
        url: url,
        start: start_datetime,
        end: end_datetime,
      )
    end

    def initialize(args)
      %i(title short_summary location url start end).each do |attribute|
        instance_variable_set("@#{attribute.to_s}", args[attribute.to_sym])
      end
    end

    def start_display
      time_display(:start)
    end

    def end_display
      time_display(:end)
    end

    private

    def time_display(ref)
      send(ref).strftime '%A, %b %-d at %-l:%M%P'
    end
  end
end
