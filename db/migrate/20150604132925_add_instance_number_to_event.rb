class AddInstanceNumberToEvent < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :events do |t|
        t.integer :event_set_instance
      end
    end
  end
end
