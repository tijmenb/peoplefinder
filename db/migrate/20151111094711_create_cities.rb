class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
    end

    add_index  :cities, :name, unique: true
    remove_column :people, :city, :string

    add_reference :people, :city, index: true
    add_foreign_key :people, :cities
  end
end
