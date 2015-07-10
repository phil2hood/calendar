class FixEventSetInCalendar < ActiveRecord::Migration
  def change
    reversible do |dir|
      add_column :event_sets, :user_calendar_id, :integer
    end
  end
end
