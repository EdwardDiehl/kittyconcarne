class UserEvent < ActiveRecord::Base
  belongs_to :event

  module Status
    SAVED = 'Saved'
    HIDDEN = 'Hidden'
  end
end
