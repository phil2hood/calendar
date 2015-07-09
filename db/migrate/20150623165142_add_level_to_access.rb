class AddLevelToAccess < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :calendar_accesses do |t|
        t.integer :event_set_instance
      end
    end
  end
end
