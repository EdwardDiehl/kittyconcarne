class HomeController < ApplicationController
  def index
    @venues = Venue.all
  end

  def events
    @events_data = [];
    
    Venue.all.each do |venue|
      @events_data.push( { venue: venue, events: venue.events } )
    end

    respond_to do |format|
      format.json { render json: @events_data }
    end
  end
end
