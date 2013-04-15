class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.integer :master_field_id
      t.integer :profile_id
      t.string :label,               :limit => 50
      t.boolean :label_hidden,       :default => false
      t.text :content
      t.integer :content_max_length, :default => 500
      t.boolean :visible,            :default => true
      t.boolean :administrative_use, :default => false
      t.boolean :user_editable,      :default => true
      t.string :style
      t.string :data_type
      t.timestamps
    end
  end
end
