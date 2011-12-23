class AddMemberSinceToProfiles < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.integer :member_since
    end
  end
end
