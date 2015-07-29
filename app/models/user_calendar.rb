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
      if event.rrule.count > 0
        rule = event.rrule.first
        Rails.logger.info "Rule #{rule.to_json}"
        interval_const = rule.interval.nil? ? 1 : rule.interval.to_i
        interval = case rule.frequency # TODO fix yearly and monthy after event set supports
                     when "MONTHLY"
                       31 * interval_const
                     when "WEEKLY"
                       7 * interval_const
                     when "YEARLY"
                       365 * interval_const
                     else
                       interval_const
                   end
        Rails.logger.info "Event name #{event.summary}, start #{event.dtstart} end #{event.dtend}"
        if event.dtend.nil?
          duration = 15
        else
          duration =  (event.dtend.to_time - event.dtstart.to_time).to_i.abs/60
        end
        if rule.until.nil?
          instances = rule.count
        else
          instances = ((rule.until.to_time - event.dtstart.to_time)/(interval * 86400)).to_i
        end
        self.event_sets.create(title: event.summary,
                               description: event.description,
                               start_at: event.dtstart,
                               duration: duration,
                               period: interval,
                               instances: instances)
      else
        self.events.create(title: event.summary,
                           description: event.description,
                           start_at: event.dtstart,
                           end_at: event.dtend)
      end
    end
  end

end
