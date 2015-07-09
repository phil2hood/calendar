class FixEventSet < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :event_sets do |t|
         t.change :duration, :integer
         t.change :period, :integer
         t.datetime :start_at
         t.remove :start
      end
    end
  end
end
