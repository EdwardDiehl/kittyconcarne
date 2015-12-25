class EventArchivingJob
  include Sidekiq::Worker

  def perform
    Event.where('date < ?', Time.now.utc)
      .where(is_archived: false)
      .update_all(is_archived: true)
  end
end
