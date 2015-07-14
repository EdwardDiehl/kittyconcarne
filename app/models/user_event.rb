class UserEvent < ActiveRecord::Base
  belongs_to :event

  module Status
    BOOKMARKED = 'bookmarked'
    ATTENDING = 'attending'
  end
end
