class SorceryExternal < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.uuid :user_id, null: false, index: true
      t.string :provider, :uid, null: false

      t.timestamps
    end
  end
end
