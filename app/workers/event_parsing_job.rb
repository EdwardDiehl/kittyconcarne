class EventParsingJob
  include Sidekiq::Worker

  def perform(venue_code)
    @venue = Venue.find_by_code(venue_code)
    return unless venue.present?

    @config = venue.parser_config
    parse_events!
  end

  private

  attr_reader :venue, :config

  def parse_events!
    fail Exceptions::EmptyCalendarError if event_list.blank?

    event_list.each do |data|
      event = parse(data)
      next unless event[:name].present?
      Event.where(event).first_or_create!
    end
  end

  def event_list
    # GET it
    source = Net::HTTP.get(config[:base_url], config[:path])
    html = Nokogiri::HTML(scrub(source))

    # Enumerate events
    calendar_html = html.css(config[:event_list])
    calendar_html.css(config[:event_list_item])
  end

  def scrub(source)
    return source unless config[:scrub].present?

    config[:scrub].each_pair do |regex, replace|
      source.gsub!(regex, replace)
    end
    source
  end

  def parse(event)
    {
      name: parse_attribute(:name, event),
      url: parse_attribute(:url, event),
      description: parse_attribute(:description, event),
      date: parse_date(:date, event),
      venue_id: venue.id
    }
  end

  # Call generic proc on event
  def parse_attribute(attribute, event)
    config[attribute].call(event)
  rescue NoMethodError
    Rails.logger.info("Could not parse #{attribute} for venue #{venue.code}")
    nil
  end

  def parse_date(attribute, event)
    date = parse_attribute(attribute, event).to_time(:utc)

    # If we go into next calendar year and assumed it was this year, add one year
    date >= Time.now.utc ? date : date + 1.year
  end
end
