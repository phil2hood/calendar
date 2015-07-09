class FixDefaultCalendar < ActiveRecord::Migration
  def change
    reversible do |dir|
      remove_column :users, :default_calendar
      add_column :users, :default_calendar_id, :integer
    end
  end
end
