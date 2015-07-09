class UserCalendar < ActiveRecord::Base
  has_many :events
  has_many :event_sets

  VISIBILITY_LEVELS=%w(PRIVATE LIMITED PUBLIC)
  validates :visibility, inclusion: {in: VISIBILITY_LEVELS}
  validates :name, presence: true

end
