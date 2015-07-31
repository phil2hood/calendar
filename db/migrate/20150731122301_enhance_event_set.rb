class EnhanceEventSet < ActiveRecord::Migration
  def change
    reversible do |dir|
      add_column :event_sets, :interval_units, :string, default: 'DAYS'
      add_column :event_sets, :has_end, :boolean, default: false
    end
  end
end
