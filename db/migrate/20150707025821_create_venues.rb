class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :code
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :address

      t.timestamps null: false
    end
  end

  def data
    Rails.logger.info('Adding Bowery Ballroom')

    bowery = Venue.where(
      code: 'BOWERY',
      name: 'Bowery Ballroom',
      latitude: 40.7204065,
      longitude: -73.9933583,
      address: '6 Delancey St'
    ).first_or_create!

    Rails.logger.info('Scheduling bowery parser job')

    EventParserWorker.perform_async(bowery.code)
  end
end
