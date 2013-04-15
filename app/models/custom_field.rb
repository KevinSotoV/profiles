class CustomField < ActiveRecord::Base

  belongs_to :master_field
  belongs_to :profile
  validates_length_of :label, :maximum => 50

  blank_to_nil

  attr_accessible :label, :label_hidden, :content, :content_max_length, :visible, :administrative_use, :user_editable, :style, :data_type, :created_by
end
