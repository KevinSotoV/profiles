class Admin::MasterFieldsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js

  def new
    @custom_field = CustomField.new
  end

  def edit
    @custom_field = @master_field.master
  end

  def update

  end

  def create
    @master_field = MasterField.new(params[:master_field])
    if @master_field.update_attributes(params[:master_field])
      if params[:master_field][:custom_field]
        cf = @master_field.custom_fields.new(params[:master_field][:custom_field])
        cf.master = true
        cf.save
      end
      @master_field.add_fields_to_models
      flash[:success] = t('admin.dashboard.custom_fields.success_create')
      respond_to do |format|
        format.html { redirect_to admin_dashboard_path}
        format.js {}
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    @master_field.destroy
    redirect_to admin_dashboard_path
  end

end
