class CreateEventSets < ActiveRecord::Migration
  def change
    create_table :event_sets do |t|
      t.string :title
      t.text :description
      t.integer :instances
      t.time :start
      t.time :duration
      t.time :period

      t.timestamps null: false
    end
  end
end
