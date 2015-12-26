class HomeController < ApplicationController
  def index
    set_uuid
    @venues = Venue.all
  end

  def events
    @events_data = []

    respond_to do |format|
      format.json do
        render json: Event.by_date_and_venue.with_status(uuid), root: nil
      end
    end
  end

  # POSTs

  def bookmark
    render json: update_event_status!(UserEvent::Status::BOOKMARKED)
  end

  def attend
    render json: update_event_status!(UserEvent::Status::ATTENDING)
  end

  def clear
    UserEvent.where(
      uuid: cookies.signed[:uuid],
      event_id: params[:event_id]
    ).destroy_all

    render json: true
  end

  private

  def set_uuid
    cookies.permanent.signed[:uuid] = SecureRandom.uuid if cookies.signed[:uuid].nil?
  end

  def uuid
    cookies.signed[:uuid]
  end

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
