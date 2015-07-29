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
    @event_sets = EventSet.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
                           where(['(DATEDIFF(DATE(?), DATE(start_at)) MOD period) = 0', day.in_time_zone(timezone).beginning_of_day])
    @event_sets.each do |es|
      sa = day.to_datetime.change(hour:es.start_at.hour, minute:es.start_at.min)
      ea = sa + es.duration.minutes
      estimated_instance = (day.to_date - es.start_at.to_date).to_i / (es.period.to_i)
      Rails.logger.info "instances #{es.instances} estimated #{estimated_instance}"
      if (estimated_instance <= es.instances &&
          es.events.where(event_set_instance: estimated_instance).count == 0)
        es.events.create(title: es.title,
                         description: es.description,
                         start_at: sa,
                         end_at: ea,
                         event_set_instance: estimated_instance,
                         user_calendar_id: es.user_calendar_id)
      end
    end
    @events = Event.where(user_calendar_id: user_calendars.pluck(:user_calendar_id)).
                    where(:start_at => day.in_time_zone(timezone).beginning_of_day..day.in_time_zone(timezone).end_of_day)
  end

  def default_calendar
    default_calendar_id ? UserCalendar.find(default_calendar_id) : user_calendars.first
  end

end
