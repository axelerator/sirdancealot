class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places, id: :uuid do |t|
      t.string :type
      t.string :name
      t.uuid :place_id, index: true
      t.string :description
    end
  end
end
