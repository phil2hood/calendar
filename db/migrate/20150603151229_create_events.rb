class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.time :start_at
      t.time :end_at
      t.text :notes

      t.timestamps null: false
    end
  end
end
