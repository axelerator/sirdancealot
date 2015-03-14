class CreateDances < ActiveRecord::Migration
  def change
    create_table :dances, id: :uuid do |t|
      t.string :name
      t.uuid :dance_id, index: true
    end

    create_table :dances_events, id: false do |t|
      t.uuid :event_id, index: true, null: false
      t.uuid :dance_id, index: true, null: false
    end

    create_table :dances_event_groups, id: false do |t|
      t.uuid :event_group_id, index: true, null: false
      t.uuid :dance_id, index: true, null: false
    end

  end
end
