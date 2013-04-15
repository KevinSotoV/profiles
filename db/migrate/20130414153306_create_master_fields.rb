class CreateMasterFields < ActiveRecord::Migration
  def change
    create_table :master_fields do |t|
      t.string :created_by
      t.string :applies_to
      t.timestamps
    end
  end
end
