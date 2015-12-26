class EventsController < HomeController
  def index
    respond_to do |format|
      format.json do
        render json: Event.by_date_and_venue.with_status(uuid), root: nil
      end
    end
  end

  # POSTs

  def save
    render json: update_event_status!(UserEvent::Status::BOOKMARKED)
  end

  def remove
    UserEvent.where(
      uuid: cookies.signed[:uuid],
      event_id: params[:event_id]
    ).destroy_all

    head :no_content
  end

  private

  # Set status for this session
  def update_event_status!(status)
    # Check that the event and cookie exist
    event = Event.find(params[:event_id])
    return false if [cookies.signed[:uuid], event].any?(&:blank?)

    # Update status
    session_user_event.update_attributes!(status: status)
    true
  end

  def session_user_event
    UserEvent.where(
      uuid: cookies.signed[:uuid],
      event_id: params[:event_id]
    ).first_or_create!
  end
end
