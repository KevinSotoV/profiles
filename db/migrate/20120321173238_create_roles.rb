class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :profile_id
      t.integer :group_id
      t.string :name

      t.timestamps
    end
  end
end
