class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions, id: :uuid do |t|
      t.string :type, null: false, index: true
      t.string :name, null: false
    end
  end
end
