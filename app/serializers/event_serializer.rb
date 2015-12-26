class EventSerializer < ActiveModel::Serializer
  attributes \
    :date,
    :description,
    :id,
    :is_saved,
    :is_seen,
    :name

  has_one  :venue

  def is_saved
    object.status == UserEvent::Status::SAVED
  end

  def is_seen
    object.status.present?
  end
end
