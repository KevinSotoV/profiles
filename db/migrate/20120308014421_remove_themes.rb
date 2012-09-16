class RemoveThemes < ActiveRecord::Migration
  def up
    drop_table :themes
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
