class Venue < ActiveRecord::Base
  BOWERY = 'BOWERY'

  has_many :events

  def self.bowery
    find_by_code(BOWERY)
  end

  def parser_config
    send("#{code.downcase}_config")
  end

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
end
