class AddEventsToCalendar < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :user_calendar_id
    end
  end
end
