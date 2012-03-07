module HomesHelper
  extend ActiveSupport::Memoizable

  def logo_image_tag
    logo = File.exist?(Rails.root.join('app/assets/images/logo.png')) ? 'logo.png' : 'logo.example.png'
    image_tag(logo, :alt => s('community.name'))
  end
  memoize :logo_image_tag
end
