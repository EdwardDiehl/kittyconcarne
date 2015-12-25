# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Venue.where(
  code: 'BOWERY',
  name: 'Bowery Ballroom',
  latitude: 40.7204065,
  longitude: -73.9933583,
  address: '6 Delancey St'
).first_or_create!

Venue.where(
  code: 'BEACON',
  name: 'Beacon Theatre',
  latitude: 40.7805215,
  longitude: -73.9810409,
  address: '2124 Broadway'
).first_or_create!

Venue.where(
  code: 'NYC_BALLET',
  name: 'New York City Ballet',
  latitude: 40.7718891,
  longitude: -73.9833398,
  address: '2124 Broadway'
).first_or_create!
