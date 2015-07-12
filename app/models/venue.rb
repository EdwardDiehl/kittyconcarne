class Venue < ActiveRecord::Base
  BOWERY = 'BOWERY'
  BEACON = 'BEACON'

  has_many :events

  def self.bowery
    find_by_code(BOWERY)
  end

  def self.beacon_theatre
    find_by_code(BEACON)
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
      title: proc { |e| e.css('.one-event').css('.url').first.text },
      description: proc { |e| e.css('.one-event').css('.supports').css('a').first.text },
      url: proc { |e| e.css('.one-event').css('.url').first['href'] },
      date: proc { |e| e.css('.date').css('span').first['title'] }
    }
  end

  def beacon_config
    {
      base_url: 'www.beacontheatre.com',
      path: '/calendar',
      scrub: {
        /alt=.*>/ => 'alt=""/>' },
      event_list: '.active',
      event_list_item: 'tr',
      title: proc { |e| e.css('.event_name').css('a').first.text },
      url: proc { |e| e.css('.event_name').css('a').first['href'] },
      date: proc { |e| e.css('.event_date').first.text + ' #{Time.now.year}' },
      description: proc { '$8000 per ticket' }
    }
  end
end
