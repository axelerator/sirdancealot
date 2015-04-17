class CreateEvents < ActiveRecord::Migration
  def change
    create_table :groups, id: :uuid do |t|
      t.string  :type, index: true

      #event_group
      t.string  :name
      t.date    :start_day
      t.date    :end_day
      t.integer :start_time
      t.integer :duration
      t.text :schedule

      #event
      t.datetime :starts_at
      t.datetime :ends_at
      t.uuid :place_id, index: true
      t.uuid :group_id

      t.timestamps
    end

    create_table :places, id: :uuid do |t|
      t.string :type, index: true
      t.string :name
      t.string :description
      t.timestamps
    end


    create_table :messages, id: :uuid do |t|
      t.text :body, null: false
      t.uuid :conversation_id, null: false
      t.timestamps
    end

  end
end
