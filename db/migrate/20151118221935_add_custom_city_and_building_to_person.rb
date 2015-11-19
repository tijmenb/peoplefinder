class AddCustomCityAndBuildingToPerson < ActiveRecord::Migration
  def change
    add_column :people, :custom_building, :string
    add_column :people, :custom_city, :string
  end
end
