class HomeController < ApplicationController
  def index
    set_uuid
    @venues = Venue.all
  end

  private

  def set_uuid
    cookies.permanent.signed[:uuid] = SecureRandom.uuid if cookies.signed[:uuid].nil?
  end

  def uuid
    cookies.signed[:uuid]
  end
end
