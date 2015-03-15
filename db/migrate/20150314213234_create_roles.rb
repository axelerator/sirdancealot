class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles, id: :uuid do |t|
      t.string :type, index: true
      t.uuid :user_id, index: true, null: false
    end
  end
end
