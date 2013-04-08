class Search < Struct.new(:q, :user)
  def initialize(params, user)
    self.q = params[:q]
    self.user = user
  end

  def show_all?
    user.active?
  end

  def profiles
    @profiles ||= begin
      if show_all?
        Profile.visible_or_user(user).where(['lower(name) like ?', "%#{self.q.downcase}%"]).all
      else
        [user.profile].compact
      end
    end
  end
end
