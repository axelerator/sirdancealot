class CreateRelationShip < ActiveRecord::Migration
  def change
    create_table :relationships, id: :uuid do |t|
      t.string :type, index: true
      t.uuid :user_id, index: true
      t.uuid :group_id, index: true
      t.uuid :place_id, index: true
      t.uuid :institution_id, index: true
      t.uuid :message_id, index: true
      t.uuid :hosted_by_institution_id, index: true
      t.integer :state
    end

    add_foreign_key :relationships, :users
    add_foreign_key :relationships, :groups
    add_foreign_key :relationships, :places
    add_foreign_key :relationships, :messages
    add_foreign_key :relationships, :institutions
    add_foreign_key :relationships, :institutions, column: :hosted_by_institution_id
  end
end
