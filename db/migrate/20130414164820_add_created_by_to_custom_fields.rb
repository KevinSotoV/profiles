class AddCreatedByToCustomFields < ActiveRecord::Migration
  def change
    change_table :custom_fields do |t|
      t.string :created_by
    end
  end
end
