class EventParserWorker
  include Sidekiq::Worker

  def perform(filename)
    html = Nokogiri::HTML(File.read(filename))

    calendar = html.css('.tfly-calendar').first
    calendar.css('.vevent').each do |event|
      info = event.css('.one-event')
      next unless info.present?

      date = event.css('.date').css('span').first
      puts date['title'] + ": " + info.css('.url').first.text
    end
  end
end
