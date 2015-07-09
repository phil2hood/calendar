class FixEventStartEnd < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :events do |t|
        t.change :start_at, :datetime
        t.change :end_at, :datetime
      end
    end
  end
end
