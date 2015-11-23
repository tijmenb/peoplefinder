class CreatePolicy < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :name
      t.string :allowed_to
    end

    add_index :policies, :name, unique: true
    add_reference :groups, :policy, index: true, foreign_key: true
  end
end
