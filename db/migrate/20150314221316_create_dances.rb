class CreateDances < ActiveRecord::Migration
  def change
    create_table :dances, id: :uuid do |t|
      t.string :name
      t.uuid :dance_id, index: true
      t.timestamps
    end

    create_table :dances_groups, id: false do |t|
      t.uuid :group_id, index: true, null: false
      t.uuid :dance_id, index: true, null: false
    end

  end
end
