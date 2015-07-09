class CreateUserCalendars < ActiveRecord::Migration
  def change
    create_table :user_calendars do |t|
      t.string :name
      t.text :description
      t.string :color
      t.string :visibility

      t.timestamps null: false
    end
  end
end
