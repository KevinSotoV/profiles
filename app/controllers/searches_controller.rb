class SearchesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_profile

  respond_to :html, :js

  def show
    @search = Search.new(params, current_user)
  end

  private

  def get_profile
    @profile = current_user.profile
    unless @profile
      flash[:warning] = t('registration.create_profile_message')
      redirect_to new_profile_path
    end
  end
end
