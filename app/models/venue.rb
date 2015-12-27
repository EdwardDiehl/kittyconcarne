class Venue < ActiveRecord::Base
  BOWERY = 'BOWERY'.freeze
  BEACON = 'BEACON'.freeze
  NYC_BALLET = 'NYC_BALLET'.freeze

  has_many :events, dependent: :destroy

  def self.bowery
    find_by_code(BOWERY)
  end

  def self.beacon_theatre
    find_by_code(BEACON)
  end

  def self.update_all!
    find_each(&:update!)
  end

  def update!
    # If venue has custom parsing logic, call that
    send("#{code.downcase}_parse!")
  rescue NoMethodError
    # Otherwise, run the job
    EventParsingJob.new.perform(code)
  end

  def parser_config
    send("#{code.downcase}_config")
  rescue NoMethodError
    nil
  end

  private

  def bowery_config
    {
      base_url: 'www.boweryballroom.com',
      path: '/calendar',
      event_list: '.tfly-calendar',
      event_list_item: '.vevent',
      name: proc { |e| e.css('.one-event').css('.url').map(&:text).join("\n") },
      description: proc do |e|
        e.css('.one-event').css('.supports').map { |s| s.css('a').first.text }.join("\n")
      end,
      url: proc { |e| e.css('.one-event').css('.url').first['href'] },
      date: proc { |e| e.css('.date').css('span').first['title'] }
    }
  end

  def bowery_presents_config
    {
      base_url: 'www.bowerypresents.com',
      path: '/calendar/',
      event_list: '.tfly-calendar',
      event_list_item: '.one-event',
      name: proc { |e| e.css('.url').map(&:text).join("\n") },
      description: proc do |e|
        e.css('.supports').map { |s| s.css('a').first.text }.join("\n")
      end,
      url: proc { |e| e.css('.url').first['href'] },
      date: proc { |e| e.parent.css('.date').css('span').first['title'] }
    }
  end

  def music_hall_of_williamsburg_config
    {
      base_url: 'www.musichallofwilliamsburg.com',
      path: '/calendar',
      event_list: '.tfly-calendar',
      event_list_item: '.vevent',
      name: proc { |e| e.css('.one-event').css('.url').map(&:text).join("\n") },
      description: proc do |e|
        e.css('.one-event').css('.supports').map { |s| s.css('a').first.text }.join("\n")
      end,
      url: proc { |e| e.css('.one-event').css('.url').first['href'] },
      date: proc { |e| e.css('.date').css('span').first['title'] }
    }
  end

  def terminal_five_config
    {
      base_url: 'www.terminal5nyc.com',
      path: '/calendar',
      event_list: '.tfly-calendar',
      event_list_item: '.vevent',
      name: proc { |e| e.css('.one-event').css('.url').map(&:text).join("\n") },
      description: proc do |e|
        e.css('.one-event').css('.supports').map { |s| s.css('a').first.text }.join("\n")
      end,
      url: proc { |e| e.css('.one-event').css('.url').first['href'] },
      date: proc { |e| e.css('.date').css('span').first['title'] }
    }
  end

  def mercury_lounge_config
    {
      base_url: 'www.mercuryloungenyc.com',
      path: '/calendar',
      event_list: '.tfly-calendar',
      event_list_item: '.vevent',
      name: proc { |e| e.css('.one-event').css('.url').map(&:text).join("\n") },
      description: proc do |e|
        e.css('.one-event').css('.supports').map { |s| s.css('a').first.text }.join("\n")
      end,
      url: proc { |e| e.css('.one-event').css('.url').first['href'] },
      date: proc { |e| e.css('.date').css('span').first['title'] }
    }
  end

  def rough_trade_config
    {
      base_url: 'www.roughtradenyc.com',
      path: '/calendar',
      event_list: '.tfly-calendar',
      event_list_item: '.vevent',
      name: proc { |e| e.css('.one-event').css('.url').map(&:text).join("\n") },
      description: proc do |e|
        e.css('.one-event').css('.supports').map { |s| s.css('a').first.text }.join("\n")
      end,
      url: proc { |e| e.css('.one-event').css('.url').first['href'] },
      date: proc { |e| e.css('.date').css('span').first['title'] }
    }
  end

  def beacon_config
    {
      base_url: 'www.beacontheatre.com',
      path: '/calendar',
      scrub: {
        /alt=.*>/ => 'alt=""/>'
      },
      event_list: '.active',
      event_list_item: 'tr',
      name: proc { |e| e.css('.event_name').css('a').first.text },
      url: proc { |e| e.css('.event_name').css('a').first['href'] },
      date: proc { |e| e.css('.event_date').first.text + " #{Time.now.utc.year}" },
      description: proc { '$8000 per ticket' }
    }
  end

  def nyc_ballet_config
    {
      base_url: 'www.nycballet.com',
      path: '/Season-Tickets/Calendar.aspx',
      event_list: '.calendarResults',
      event_list_item: '.results',
      name: proc do |e|
        event = e.css('.performancesList').css('.second')
        event.present? ? event.last.css('li').text : nil
      end,
      url: proc do |e|
        event = e.css('.performancesList').css('.second')
        event.present? ? event.css('a').first['href'] : nil
      end,
      date: proc { |e| e.css('header').css('h6').text + " #{Time.now.utc.year}" },
      description: proc do |e|
        event = e.css('.performancesList').css('.collapse').css('.text')
        event.present? ? event.text : nil
      end
    }
  end

  # Almost as flimsy as the website it's scraping
  def webster_hall_parse!
    response = Net::HTTP.get('api.ticketweb.com', '/snl/EventAPI.action?key=kFiQQQiHkGJpeA5xCfHd&version=1&orgId=136373,141422,137573&method=json')
    json = JSON.parse(response)

    json['events'].each do |event|
      Event.where(
        name: event['eventname'],
        description: event['description'],
        url: event['eventurl'],
        date: event['dates']['startdate'].to_time("Eastern Time (US & Canada)").utc,
        venue_id: id
      ).first_or_create!
    end
  end
end
