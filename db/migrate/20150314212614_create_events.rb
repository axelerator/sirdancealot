class CreateEvents < ActiveRecord::Migration
  def change
    create_table :institutions, id: :uuid do |t|
      t.string :type, null: false, index: true
      t.string :name, null: false
    end

    create_table :event_groups, id: :uuid do |t|
      t.string :type, index: true
      t.string :name
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.text :schedule
    end

    create_table :places, id: :uuid do |t|
      t.string :type, index: true
      t.string :name
      t.string :description
    end

    create_table :events, id: :uuid do |t|
      t.string :type, index: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.uuid :place_id, index: true, null: false
      t.uuid :event_group_id, index: true, null: false
    end

    add_foreign_key :events, :places
    add_foreign_key :events, :event_groups
  end
end
