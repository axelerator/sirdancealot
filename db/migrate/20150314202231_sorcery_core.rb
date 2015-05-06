class SorceryCore < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
    create_table :users, id: :uuid do |t|
      t.string :email,            :null => false
      t.string :crypted_password, :null => false
      t.string :salt,             :null => false
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_column :users, :profile_image_uid,  :string
    add_column :users, :profile_image_name, :string
  end
end
