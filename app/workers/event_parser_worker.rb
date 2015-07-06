class EventParserWorker
  include Sidekiq::Worker

  def perform
    source = Net::HTTP.get('www.boweryballroom.com', '/calendar')
    html = Nokogiri::HTML(source)

    calendar = html.css('.tfly-calendar').first
    calendar.css('.vevent').each do |event|
      info = event.css('.one-event')
      next unless info.present?

      date_html = event.css('.date').css('span').first
      date = date_html['title']

      url_html = info.css('.url').first
      title = url_html.text
      url = url_html['href']

      description_html = info.css('.supports').css('a').first
      description = description_html.text if description_html.present?

      Event.create!(
        name: title,
        url: url,
        description: description,
        date: date
      )
    end
  end
end
