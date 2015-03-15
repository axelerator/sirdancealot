class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events, id: :uuid do |t|
      t.string :type, index: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.uuid :place_id, index: true, null: false
    end
  end
end
