class GroupsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource # sets @group

  respond_to :html, :js

  def index
    @groups = Group.select('*, (select count(*) from roles where group_id=groups.id) as profile_count').all
  end

  def show
    @roles = @group.roles.includes(:profile).order("case when roles.name is null then 'z' else 'a' end, profiles.name")
  end
end
