class EventParserWorker
  include Sidekiq::Worker

  def perform
    bowery = Venue.where(
      name: 'Bowery Ballroom',
      latitude: 40.7204065,
      longitude: -73.9933583,
      address: '6 Delancey St'
    ).first_or_create!

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
        date: date,
        venue_id: bowery.id
      )
    end
  end
end
