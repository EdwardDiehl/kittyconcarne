class EventsController < HomeController
  after_filter :set_events_to_seen

  def index
    respond_to do |format|
      format.json do
        render json: Event.by_date_and_venue.with_status(uuid), root: nil
      end
    end
  end

  # POSTs

  def save
    update_event_status!(UserEvent::Status::SAVED)
    head :no_content
  end

  def remove
    update_event_status!(UserEvent::Status::SEEN)
    head :no_content
  end

  private

  def set_events_to_seen
    Event.with_no_status(uuid).find_each do |event|
      UserEvent.create_seen_status!(event: event, uuid: uuid)
    end
  end

  # Set status for this session
  def update_event_status!(status)
    event = Event.find(params[:event_id])
    return if [cookies.signed[:uuid], event].any?(&:blank?)

    session_user_event.update_attributes!(status: status)
  end

  def session_user_event
    UserEvent.where(
      uuid: cookies.signed[:uuid],
      event_id: params[:event_id]
    ).first_or_create!
  end
end
