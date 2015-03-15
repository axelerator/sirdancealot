class CreateRelationShip < ActiveRecord::Migration
  def change
    create_table :relationships, id: :uuid do |t|
      t.string :type, index: true
      t.uuid :user_id, index: true, null: false
      t.uuid :event_id, index: true
      t.uuid :event_group_id, index: true
      t.uuid :institution_id, index: true
    end
  end
end
