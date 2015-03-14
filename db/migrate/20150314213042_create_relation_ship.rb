class CreateRelationShip < ActiveRecord::Migration
  def change
    create_table :relation_ships, id: :uuid do |t|
      t.string :type
      t.uuid :user_id, index: true, null: false
      t.uuid :event_id, index: true
      t.uuid :event_group_id, index: true
    end
  end
end
