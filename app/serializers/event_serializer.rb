class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :description, :status

  has_one  :venue
end
