class CalendarAccess < ActiveRecord::Base
  belongs_to :user_calendar, dependent: :destroy
  belongs_to :user, dependent: :destroy
  ACCESS_LEVELS=%w(FULL WRITE READ)
  validates :access_level, inclusion: {in: ACCESS_LEVELS}
end
