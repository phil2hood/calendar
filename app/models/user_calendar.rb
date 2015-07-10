class UserCalendar < ActiveRecord::Base
  has_many :events
  has_many :event_sets

  VISIBILITY_LEVELS=%w(PRIVATE LIMITED PUBLIC)
  validates :visibility, inclusion: {in: VISIBILITY_LEVELS}
  validates :name, presence: true

  def import_events(ics_file)
    cal_file = File.open(ics_file)
    cals = Icalendar.parse(cal_file)
    cal = cals.first
    cal.events.each do |event|
      self.events.create(title: event.summary,
                         description:event.description,
                         start_at: event.dtstart,
                         end_at: event.dtend)
    end
  end

end
