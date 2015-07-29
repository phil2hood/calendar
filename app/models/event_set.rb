class EventSet < ActiveRecord::Base
  belongs_to :user_calendar
  has_many :events
  validates :title, :duration, :instances, presence:true

  # TODO need to support monthly and yearly events

  def start_at
    read_attribute(:start_at) || Time.now
  end


end
