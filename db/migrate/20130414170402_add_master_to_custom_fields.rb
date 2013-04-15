class AddMasterToCustomFields < ActiveRecord::Migration
  def change
    change_table :custom_fields do |t|
      t.boolean :master, :default => false
    end
  end
end
