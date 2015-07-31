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
        #Rails.logger.info "Rule #{rule.to_json}"
        if rule.interval.nil?
          interval = 1
          interval_units = 'DAYS'
        else
          case rule.frequency # TODO fix yearly and monthy after event set supports
            when "MONTHLY"
              interval_units = 'MONTHS'
              interval = rule.interval.to_i
            when "WEEKLY"
              interval_units = 'DAYS'
              interval = 7 * rule.interval.to_i
            when "YEARLY"
              interval_units = 'YEARS'
              interval = rule.interval.to_i
            else
              interval_units = 'DAYS'
              interval = rule.interval.to_i
          end
        end
        #Rails.logger.info "Event name #{event.summary}, start #{event.dtstart} end #{event.dtend}"
        if event.dtend.nil?
          duration = 15
        else
          duration = (event.dtend.to_time - event.dtstart.to_time).to_i.abs/60
        end
        if rule.count.nil? && rule.until.nil?
          instances = 0
          has_end = false
        else
          if rule.until.nil?
            instances = rule.count
            has_end = true
          else
            instances = ((rule.until.to_time - event.dtstart.to_time)/(interval * 86400)).to_i
            has_end = true
          end
        end
        self.event_sets.create(title: event.summary,
                               description: event.description,
                               start_at: event.dtstart,
                               duration: duration,
                               period: interval,
                               interval_units: interval_units,
                               instances: instances,
                               has_end: has_end)
      else
        self.events.create(title: event.summary,
                           description: event.description,
                           start_at: event.dtstart,
                           end_at: event.dtend)
      end
    end
  end

end
