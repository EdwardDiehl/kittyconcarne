class HomeController < ApplicationController
  def index
    set_uuid
    @venues = Venue.all
  end

  def events
    @events_data = []

    Venue.all.each do |venue|
      @events_data.push( { venue: venue, events: venue.events.with_status(uuid) } )
    end

    respond_to do |format|
      format.json { render json: @events_data }
    end
  end

  # POSTs

  def save_event
    event = Event.find(params[:event_id])
    return if [cookies.signed[:uuid], event].any?(&:blank?)

    user_event = UserEvent.where(
      uuid: cookies.signed[:uuid],
      event_id: event.id
    ).first_or_create!

    user_event.update_attributes!(status: UserEvent::Status::SAVED)
    render json: true
  end

  private

  def set_uuid
    cookies.permanent.signed[:uuid] = SecureRandom.uuid if cookies.signed[:uuid].nil?
  end

  def uuid
    cookies.signed[:uuid]
  end
end
