class Fix < ActiveRecord::Migration
  def change
    reversible do |dir|
      remove_column :users, :deault_calendar
      add_column :users, :default_calendar, :integer
    end
  end
end
