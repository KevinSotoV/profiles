class MasterField < ActiveRecord::Base

  has_many :custom_fields, :dependent => :destroy


  blank_to_nil

  attr_accessible :created_by, :applies_to

  def master
    self.custom_fields.where(:master => true).first
  end

  def add_fields_to_models
    master = self.custom_fields.where(:master => true).first
    if self.applies_to == "Profile"
      @profiles = Profile.all
      @profiles.each do |p|
        cf = p.custom_fields.new
        cf.update_attributes(:label => master.label,
                             :label_hidden => master.label_hidden,
                             :content => master.content,
                             :content_max_length => master.content_max_length,
                             :visible => master.visible,
                             :administrative_use => master.administrative_use,
                             :user_editable => master.user_editable,
                             :style => master.style,
                             :data_type => master.data_type,
                             :created_by => master.created_by)
        cf.master_field_id = self.id
        cf.save
      end
    end
  end

end
