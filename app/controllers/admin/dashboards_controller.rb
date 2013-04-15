class Admin::DashboardsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin!

  def show
    @actions = AdminActionsPresenter.new
    @stats = AdminStatsPresenter.new
    @custom_fields = AdminCustomFieldsPresenter.new
  end
end
