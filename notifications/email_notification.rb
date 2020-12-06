require 'net/smtp'

module EmailNotification
  class Notification
    attr_accessor :subject, :desciption, :date, :settings, :url
    attr_reader :env

    class << self
      def from_event(event)
        new(
          subject: nil,
          desciption: event.short_summary,
          date: event.start_display,
          url: event.url
        )
      end
    end

    def initialize(subject:, desciption:, date:, url:)
      @subject = 'Space Launch comming soon!'
      @desciption = desciption
      @date = date
      @url = url

      load_env
      set_default_smtp_settings
    end

    def fire!
      smtp = Net::SMTP.new settings[:host], settings[:port]
      smtp.enable_starttls_auto
      smtp.start(env['SMTP_HOST'], settings[:SMTP_USERNAME], settings[:SMTP_PASSWORD], :login) do |session|
        session.enable_starttls_auto
        session.send_message build_email_message, settings[:from_email], settings[:to]
      end
    end

    def to_formatted
      settings[:to].map { |addr| "<#{addr}>" }.join(',')
    end

    private

    def set_default_smtp_settings
      raise 'You must load ENV first, call :load_env' if @env.nil?

      @settings = {
        from_email: "no-reply@kevinmircovich.com",
        from_name: "Rocket Bot",
        reply_to_email: "kmircovich1@gmail.com",
        reply_to_name: "Kevin Mircovich",
        to: env['SMTP_SUBSCRIBERS_CSV'].split(','),
        SMTP_USERNAME: env['SMTP_USERNAME'],
        SMTP_PASSWORD: env['SMTP_PASSWORD'],
        host: env['SMTP_HOST'],
        port: 587,
        subject: subject,
        body_html: build_email_message_body
      }
    end

    def build_email_message
      lines = [
        "From: #{settings[:from_name]} <#{settings[:from_email]}>",
        "To: #{to_formatted}",
        "Reply-To: \"#{settings[:reply_to_name]}\" <#{settings[:reply_to_email]}>",
        "Subject: #{settings[:subject]}",
        "Content-Type: text/html",
        "",
        "#{settings[:body_html]}",
        ""
      ]

      lines.join("\n")
    end

    def build_email_message_body
      lines = [
        "<p>🚀</p>",
        "<p>On <span style=\"color:#d30000;font-weight:bold;\">#{date}</span>, #{desciption}</p>",
        "<p><a href=\"#{url}\">Click here</a> to get the deets!</p>",
        ""
      ]

      lines.join("\n")
    end

    def load_env
      @env ||= File.read('./.env')
      .split("\n")
      .filter { |line| line[0] != '#' }
      .each_with_object({}) { |cred_pair, obj| creds = cred_pair.split('='); obj[creds[0]] = creds[1]  }
    rescue
      raise 'Failure to load .env'
    end
  end
end
