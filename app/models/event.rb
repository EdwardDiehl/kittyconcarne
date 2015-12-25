class Event < ActiveRecord::Base
  belongs_to :venue
  has_many :user_events, dependent: :destroy

  default_scope { where(is_archived: false) }

  def self.chronological
    order(:date)
  end

  def self.by_date_and_venue
    order(:date, :venue_id)
  end

  # Get any statuses for this user-ish
  def self.with_status(uuid)
    return self if uuid.blank?
    joins('LEFT JOIN user_events '\
      'ON user_events.event_id = events.id '\
      "AND user_events.uuid = '#{uuid}'")
    .select('events.*, user_events.status')
  end
end
