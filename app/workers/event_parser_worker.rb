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
      title = parse_attribute('title', event)
      url = parse_attribute('url', event)
      description = parse_attribute('description', event)
      date = parse_attribute('date', event)

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
    html = Nokogiri::HTML(scrub(source))

    # Enumerate events
    calendar_html = html.css(config[:event_list])
    calendar_html.css(config[:event_list_item])
  end

  def scrub(source)
    return source unless config[:scrub].present?

    config[:scrub].each_pair do |regex, replace|
      source = source.gsub(regex, replace)
    end
    source
  end

  # Call generic proc on event
  def parse_attribute(attribute, event)
    config[attribute.to_sym].call(event)
  rescue NoMethodError
    Rails.logger.info("Could not parse #{attribute} for event")
    nil
  end
end
