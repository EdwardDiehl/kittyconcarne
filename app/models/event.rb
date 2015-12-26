class Event < ActiveRecord::Base
  belongs_to :venue
  has_many :user_events, dependent: :destroy

  default_scope { where(is_archived: false) }

  class << self
    def chronological
      order(:date)
    end

    def by_date_and_venue
      includes(:venue)
        .order(:date, :venue_id)
    end

    def with_status(uuid)
      with_user_event_status(uuid)
        .select('events.*, user_events.status')
    end

    def with_no_status(uuid)
      with_user_event_status(uuid)
        .where(user_events: { id: nil })
    end

    def bookmarked(uuid)
      with_status(uuid)
        .where('status = ?', UserEvent::Status::BOOKMARKED)
    end

    private

    # Left join the event status for this user, because it may not be set
    def with_user_event_status(uuid)
      joins('LEFT JOIN user_events '\
        'ON user_events.event_id = events.id '\
        "AND user_events.uuid = '#{uuid}'")
    end
  end
end
