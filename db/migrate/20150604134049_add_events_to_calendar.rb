class AddEventsToCalendar < ActiveRecord::Migration
  def change
    change_table :calendar_accesses do |t|
      t.string :access_level
    end
  end
end
