class HomeController < ApplicationController
  def index
    cookies.permanent.signed[:uuid] = SecureRandom.uuid if cookies.signed[:uuid].nil?
    @venues = Venue.all
  end

  def events
    @events_data = []

    Venue.all.each do |venue|
      @events_data.push( { venue: venue, events: venue.events } )
    end

    respond_to do |format|
      format.json { render json: @events_data }
    end
  end

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
end
