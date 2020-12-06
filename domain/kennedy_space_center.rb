require 'uri'
require 'net/http'
require 'json'

require_relative './kennedy_space_center/event'

class KennedySpaceCenter
  class << self
    def uri
      URI('https://www.kennedyspacecenter.com/api/sitecore/Event/GetFutureEvents')
    end

    def upcoming_events
      fetch_events.map { |raw_event| Event.from_raw(raw_event, uri) }
    end

    private

    def mock_fetch_events
      JSON.parse(File.read('./fixtures/sample-response.json'))
    end

    def fetch_events
      res = Net::HTTP.post self.uri, request_body.to_json, request_headers
      body = JSON.parse(
        JSON.parse(
          res.body
        )["JsonResult"]
      )
    end

    def request_headers
      { "Content-Type" => "application/json" }
    end

    def request_body
      # The Kennedy Space Center makes this request with the empty strings and stringified Sets as shown
      {
        "startDate" => "",
        "endDate" => "",
        "datasourceID" => "{5CEC271B-AFD1-4DC5-B872-E450B9CA1B1D}",
        "categoryList" => "{C5A59F38-0044-45B3-A04B-BCA1FC9F5344}",
        "Query" => "",
        "PageIndex" => 1,
        "PageSize" => "0",
        "Start" => ""
      }
    end
  end
end
