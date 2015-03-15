class CreateEventGroup < ActiveRecord::Migration
  def change
    create_table :event_groups, id: :uuid do |t|
      t.string :type, index: true
      t.string :name
    end

    add_column :events, :event_group_id, :uuid, null: false, index: true
  end
end
