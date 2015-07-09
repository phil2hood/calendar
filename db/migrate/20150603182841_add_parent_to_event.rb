class AddParentToEvent < ActiveRecord::Migration
  def change
      reversible do |dir|
        change_table :events do |t|
          t.integer :event_set_id
        end
      end
  end
end
