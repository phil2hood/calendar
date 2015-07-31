class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :calendar_accesses
  has_many :user_calendars, through: :calendar_accesses
  belongs_to :default_calendar, class: UserCalendar

  # TODO prevent casual users from taking over the system
  # USER_TYPES = %w(DEMO FULL ADMIN)

  def appointments(day)
#    @event_sets = EventSet.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
#                           where(["(DATEDIFF(DATE(?), DATE(start_at)) MOD period) = 0 AND interval_units = 'DAYS'",
#                                  day.in_time_zone(timezone).beginning_of_day])
#    @event_sets.each do |es|
#      sa = day.to_datetime.change(hour:es.start_at.hour, minute:es.start_at.min)
#      ea = sa + es.duration.minutes
#      estimated_instance = (day.to_date - es.start_at.to_date).to_i / (es.period.to_i)
#      #Rails.logger.info "instances #{es.instances} estimated #{estimated_instance}"
#      if (((!es.has_end) || estimated_instance <= es.instances)&&
#          es.events.where(event_set_instance: estimated_instance).count == 0)
#        es.events.create(title: es.title,
#                         description: es.description,
#                         start_at: sa,
#                         end_at: ea,
#                         event_set_instance: estimated_instance,
#                         user_calendar_id: es.user_calendar_id)
#      end
#    end
#    @event_sets = EventSet.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
#        where(["(TIMESTAMPDIFF(MONTH, DATE(?), start_at) MOD period) = 0 AND interval_units = 'MONTHS'",
#               day.in_time_zone(timezone).beginning_of_day])
#    @event_sets.each do |es|
#      sa = day.to_datetime.change(hour:es.start_at.hour, minute:es.start_at.min)
#      ea = sa + es.duration.minutes
#      estimated_instance = (day.to_date - es.start_at.to_date).month.to_i / (es.period.to_i)
#      #Rails.logger.info "instances #{es.instances} estimated #{estimated_instance}"
#      if (((!es.has_end) || estimated_instance <= es.instances)&&
#          es.events.where(event_set_instance: estimated_instance).count == 0)
#        es.events.create(title: es.title,
#                         description: es.description,
#                         start_at: sa,
#                         end_at: ea,
#                         event_set_instance: estimated_instance,
#                         user_calendar_id: es.user_calendar_id)
#      end
#    end
#    @event_sets = EventSet.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
#        where(["(TIMESTAMPDIFF(YEAR, DATE(?), start_at) MOD period) = 0 AND interval_units = 'YEARS'",
#               day.in_time_zone(timezone).beginning_of_day])
#    @event_sets.each do |es|
#      sa = day.to_datetime.change(hour:es.start_at.hour, minute:es.start_at.min)
#      ea = sa + es.duration.minutes
#      estimated_instance = (day.to_date - es.start_at.to_date).year.to_i / (es.period.to_i)
#      #Rails.logger.info "instances #{es.instances} estimated #{estimated_instance}"
#      if (((!es.has_end) || estimated_instance <= es.instances)&&
#          es.events.where(event_set_instance: estimated_instance).count == 0)
#        es.events.create(title: es.title,
#                         description: es.description,
#                         start_at: sa,
#                         end_at: ea,
#                         event_set_instance: estimated_instance,
#                         user_calendar_id: es.user_calendar_id)
#      end
#    end
    project_events(day, 'DAYS')
    project_events(day, 'MONTHS')
    project_events(day, 'YEARS')
    @events = Event.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
                    where(:start_at => day.in_time_zone(timezone).beginning_of_day..day.in_time_zone(timezone).end_of_day)
  end

  def project_events (day, increment)
    @event_sets = EventSet.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
        where(["(TIMESTAMPDIFF(#{increment.singularize}, start_at, ?) MOD period) = 0 AND interval_units = '#{increment}'",
               day.in_time_zone(timezone).end_of_day])
    @event_sets.each do |es|
      sa = day.to_datetime.change(hour:es.start_at.hour, minute:es.start_at.min)
      ea = sa + es.duration.minutes
      estimated_instance = (day.to_date - es.start_at.to_date).send(increment.downcase.singularize.to_sym).to_i / (es.period.to_i)
      #Rails.logger.info "instances #{es.instances} estimated #{estimated_instance}"
      if (((!es.has_end) || estimated_instance <= es.instances)&&
          es.events.where(event_set_instance: estimated_instance).count == 0)
        es.events.create(title: es.title,
                         description: es.description,
                         start_at: sa,
                         end_at: ea,
                         event_set_instance: estimated_instance,
                         user_calendar_id: es.user_calendar_id)
      end
    end
  end

  def default_calendar
    default_calendar_id ? UserCalendar.find(default_calendar_id) : user_calendars.first
  end

end
