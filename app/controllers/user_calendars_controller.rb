class UserCalendarsController < ApplicationController
  def create
    new_cal = UserCalendar.create(calendar_params)
    CalendarAccess.create(user_id: current_user.id,
                          user_calendar_id: new_cal.id,
                          access_level: 'FULL')
    @calendars = current_user.user_calendars
    render :index
  end

  def update
    @calendar = UserCalendar.find(params['id'])
    @calendar.update_attributes(calendar_params)
    @calendars = current_user.user_calendars
    render :index
  end

  def destroy
    target_cal = UserCalendar.find(params['id'])
    cal_access = current_user.calendar_accesses.where(user_calendar_id: target_cal.id).first
    if cal_access.access_level == 'FULL' # You can only delete you own calendars
      target_cal.destroy
    else # otherwise we just remove your access
      cal_access.destroy
    end
    @calendars = current_user.user_calendars
    render :index
  end

  def index
    @calendars = current_user.user_calendars
  end

  def new
    @calendar = UserCalendar.new
    render :edit
  end

  def edit
    @calendar = UserCalendar.find(params['id'])
  end

  def import
    @calendar = UserCalendar.find(params['import_calendar_id'])
    in_cal = params[:import_file]
    @calendar.import_events(in_cal.tempfile)
    redirect_to '/'
  end

  def export

  end

  private

  def calendar_params
    params.require(:user_calendar).permit(:name, :description, :color, :visibility)
  end
end
