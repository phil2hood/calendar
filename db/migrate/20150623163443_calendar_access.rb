class CalendarAccess < ActiveRecord::Migration
  def change
    create_table :calendar_accesses do |t|
      t.integer :user_calendar_id
      t.integer :user_id
      t.string :color
      t.timestamps null: false
    end
  end
end
