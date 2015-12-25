class Event < ActiveRecord::Base
  belongs_to :venue
  has_many :user_events

  default_scope { where(is_archived: false) }

  # Get any statuses for this user-ish
  def self.with_status(uuid)
    return self if uuid.blank?
    joins('FULL OUTER JOIN user_events '\
      'ON user_events.event_id = events.id '\
      "AND user_events.uuid = '#{uuid}'")
      .select('events.*, user_events.status')
  end
end
