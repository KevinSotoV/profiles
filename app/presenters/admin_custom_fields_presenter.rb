class AdminCustomFieldsPresenter
  def master_fields
    master_fields = {}
    m_fields = MasterField.all
    m_fields.each do |m|
      master_fields = master_fields.merge({m => m.custom_fields.where(:master => true).first})
    end
    return master_fields
  end

end
