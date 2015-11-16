class AddStaffNrToPerson < ActiveRecord::Migration
  def change
    add_column :people, :staff_nr, :string
  end
end
