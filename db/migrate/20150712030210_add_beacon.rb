class AddBeacon < ActiveRecord::Migration
  def change
    # nothing
  end

  def data
    beacon = Venue.where(
      code: 'BEACON',
      name: 'Beacon Theatre',
      latitude: 40.7805215,
      longitude: -73.9810409,
      address: '2124 Broadway'
    ).first_or_create!

    EventParserWorker.perform_async(beacon.code)
  end
end
