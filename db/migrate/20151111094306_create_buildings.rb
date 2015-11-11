class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :address
    end

    add_index  :buildings, :address, unique: true
    remove_column :people, :building, :string

    add_reference :people, :building, index: true
    add_foreign_key :people, :buildings
  end
end
