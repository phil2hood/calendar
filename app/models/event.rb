class Event < ActiveRecord::Base
  belongs_to :user_calendar
  has_one :event_set
  validates :title, presence:true

  def start_at
    read_attribute(:start_at) || Time.now
  end

  def end_at
    read_attribute(:end_at) || Time.now + 30.minutes
  end

end
