class EventsController < ApplicationController
  respond_to :json

  def embedded_index
    @day = Date.parse(params[:date])
    @events = current_user.appointments(@day)
  end

  def embedded_edit
    @event = Event.find(params[:id])
  end
  def embedded_new
    @event = Event.new
    @event.user_calendar = current_user.default_calendar
  end
  def embedded_update
    tz = ActiveSupport::TimeZone.new(current_user.timezone)
    up_params = event_params
    up_params[:start_at] = tz.parse(up_params['start_at']).utc.to_s
    up_params[:end_at] = tz.parse(up_params['end_at']).utc.to_s
    @event = Event.find(params['event_id'])
    @old_day = @event.start_at.to_date
    Rails.logger.info "params #{up_params}"
    @event.update_attributes(up_params)
    @day = @event.start_at.to_date
    @events = current_user.appointments(@day)
    @old_day_events = current_user.appointments(@old_day)
    render :move_event
  end

  def embedded_create
    tz = ActiveSupport::TimeZone.new(current_user.timezone)
    up_params = event_params
    up_params[:start_at] = tz.parse(up_params['start_at']).utc.to_s
    up_params[:end_at] = tz.parse(up_params['end_at']).utc.to_s
    @event = Event.create(up_params)
    @day = @event.start_at.to_date
    @events = current_user.appointments(@day)
    render :embedded_index
  end

  def move_event
    @event = Event.find(params[:event_id])
    duration =  @event.end_at.to_time - @event.start_at.to_time
    @old_day = @event.start_at.to_date
    @day = Date.parse(params[:target_date])
    hours = params[:target_hour].to_f
    start_at = (@day.to_time + hours * 3600)
    adjust_sec = start_at.sec
    adjust_min  = start_at.min % current_user.snap_to_minutes
    Rails.logger.info "Adjusting #{start_at.to_s} by #{adjust_min} minutes and #{adjust_sec} seconds"
    @event.start_at =  start_at - adjust_min.minutes - adjust_sec.seconds
    @event.end_at = start_at + duration.seconds
    @event.save
    @old_day_events = current_user.appointments(@old_day)
    @events = current_user.appointments(@day)
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :notes, :start_at, :end_at, :user_calendar_id)
  end
end
