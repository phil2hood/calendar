class AddFieldsToUser < ActiveRecord::Migration
  def change
    reversible do |dir|
      add_column :users, :snap_to_minutes, :integer, default: 15
      add_column :users, :deault_calendar, :integer
      add_column :users, :timezone, :string, default: 'America/New_York'
    end
  end
end
