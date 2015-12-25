class Venue < ActiveRecord::Base
  BOWERY = 'BOWERY'.freeze
  BEACON = 'BEACON'.freeze
  NYC_BALLET = 'NYC_BALLET'.freeze

  has_many :events

  def self.bowery
    find_by_code(BOWERY)
  end

  def self.beacon_theatre
    find_by_code(BEACON)
  end

  def self.update_all!
    find_each { |venue| EventParsingJob.new.perform(venue.code) }
  end

  def parser_config
    send("#{code.downcase}_config")
  end

  private

  def bowery_config
    {
      base_url: 'www.boweryballroom.com',
      path: '/calendar',
      event_list: '.tfly-calendar',
      event_list_item: '.vevent',
      name: proc { |e| e.css('.one-event').css('.url').first.text },
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
end
