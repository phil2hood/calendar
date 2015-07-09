class EventSetsController < ApplicationController
  respond_to :json


  def embedded_new
    @event_set = EventSet.new
  end

  def embedded_create
    tz = ActiveSupport::TimeZone.new(current_user.timezone)
    up_params = event_set_params
    up_params[:start_at] = tz.parse(up_params['start_at']).utc.to_s
    @event_set = EventSet.create(up_params)
    redirect_to :weekly_event_sets_path
  end

  def embedded_edit
     @event_set = EventSet.find(params[:id])
  end

  def embedded_update
    tz = ActiveSupport::TimeZone.new(current_user.timezone)
    up_params = event_set_params
    up_params[:start_at] = tz.parse(up_params['start_at']).utc.to_s
    @event_set = EventSet.find(params[:id])
    @event_set.update_attributes(up_params)
    redirect_to :weekly
  end

  def weekly
    @day = params[:day] ? Date.parse(params[:day]) : Date.today
    @first_day = @day.at_beginning_of_week
    @last_day = @first_day + 6.days
  end

  private

  def event_set_params
    params.require(:event_set).permit(:title, :description, :instances, :start_at, :duration, :period, :user_calendar_id)
  end
end
