class EventParserWorker
  include Sidekiq::Worker

  def perform(venue_code)
    @venue = Venue.find_by_code(venue_code)
    return unless venue.present?

    @config = venue.parser_config
    parse_events!

  rescue StandardError => e
    Rails.logger.error(e)
  end

  private

  attr_reader :venue, :config

  def parse_events!
    event_list.each do |event|
      title = title_for(event)
      url = url_for(event)
      description = description_for(event)
      date = date_for(event)

      Rails.logger.info(event) if [title, url, description, date].any?(&:blank?)

      # Require title
      next unless title.present?

      Event.create!(
        name: title,
        url: url,
        description: description,
        date: date,
        venue_id: venue.id
      )
    end
  end

  def event_list
    # GET it
    source = Net::HTTP.get(config[:base_url], config[:path])
    html = Nokogiri::HTML(source)

    # Enumerate events
    calendar_html = html.css(config[:event_list])
    calendar_html.css(config[:event_list_item])
  end

  # Call title proc defined in Venue config
  def title_for(event)
    config[:title].call(event)
  rescue NoMethodError
    Rails.logger.info("Could not parse title for event")
    nil
  end

  # Call url proc defined in Venue config
  def url_for(event)
    config[:url].call(event)
  rescue NoMethodError
    Rails.logger.info("Could not parse url for event")
    nil
  end

  # Call description proc defined in Venue config
  def description_for(event)
    config[:description].call(event)
  rescue NoMethodError
    Rails.logger.info("Could not parse description for event")
    nil
  end

  # Call date proc defined in Venue config
  def date_for(event)
    config[:date].call(event)
  rescue NoMethodError
    Rails.logger.info("Could not parse date for event")
    nil
  end
end
