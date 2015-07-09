class FixAccessLevel < ActiveRecord::Migration
  def change
    add_column :calendar_accesses, :access_level, :string
    remove_column :calendar_accesses, :event_set_instance
  end
end
