module HomesHelper
  def home?
    params[:controller] == 'homes'
  end
end
