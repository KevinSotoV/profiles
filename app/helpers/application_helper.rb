module ApplicationHelper
  extend ActiveSupport::Memoizable

  def logo_image_tag
    logo = File.exist?(Rails.root.join('app/assets/images/logo.png')) ? 'logo.png' : 'logo.default.png'
    image_tag(logo, :alt => s('community.name'))
  end
  memoize :logo_image_tag

  def bg_style_tag
    path = File.exist?(Rails.root.join('app/assets/images/bg.jpg')) ? 'bg.jpg' : 'bg.default.jpg'
    style = ".bg { background: url(/assets/#{path}) top left no-repeat; background-size: cover; }"
    content_tag(:style, style, :type => 'text/css').html_safe
  end

  def footer_content
    content_tag(:footer) do
      I18n.t('footer.copyright_html', :year => Date.today.year, :name => Setting.s('community.name')).html_safe +
      ' &middot; '.html_safe +
      link_to(I18n.t('pages.privacy_policy'), '/pages/privacy_policy') +
      ' &middot; '.html_safe +
      I18n.t('app.powered_by_html').html_safe +
      if home? && credit = s('home.bg_credit')
        "<br/> #{h credit}"
      end.to_s.html_safe
    end
  end

  def flash_messages
    [:info, :success, :warning, :error, :alert, :notice].map do |type|
      if flash[type]
        content_tag(:div, :class => "alert-box #{type}") do
          close_button + content_tag(:p, h(flash[type]))
        end
      end
    end.join.html_safe
  end

  def errors_for(form_or_resource, options={})
    if form_or_resource.respond_to?(:object)
      obj = form_or_resource.object
    else
      obj = form_or_resource
    end
    if obj.errors.any?
      content_tag(:div, :class => 'error_explanation') do
        content_tag(:h3, t('feedback.form_errors_heading')) +
        content_tag(:ul) do
          obj.errors.map do |attribute, message|
            if !options[:only] or options[:only].include?(attribute)
              content_tag(:li, h(message))
            end
          end.join.html_safe
        end
      end
    end
  end

  def simple_url(url)
    url.to_s.sub(/^https?:\/\/(www\.)?/, '')
  end

  def close_button
    link_to '&#215;'.html_safe, '#', :class => 'close' 
  end

  def sanitize(html)
    Sanitize.clean(html, Sanitize::Config::BASIC).html_safe
  end

  # tab_link ['text',] url, [default=false]
  def tab_link(*args, &block)
    if [Symbol, TrueClass, FalseClass].include?(args.last.class)
      default = args.pop 
    else
      default = false
    end
    if args.length == 1
      content = capture(&block)
      href = args[0]
    else
      content, href = args
    end
    class_name = (params[:tab].nil? && default) || params[:tab] == href.to_s.sub(/^#/, '') ? 'active' : ''
    content_tag(:li, :class => class_name) do
      link_to(content, href)
    end
  end

  def tab_content(id, default=false, &block)
    id.sub!(/^#/, '')
    content = capture(&block)
    class_name = (params[:tab].nil? && default) || params[:tab] == id ? 'active' : ''
    content_tag(:div, :id => id, :class => class_name) do
      content
    end
  end

  def check_box_fields(label, fields)
    content_tag(:div, :class => 'clearfix') do
      label_tag(fields.first[:name], label) +
      content_tag(:div, :class => 'input') do
        content_tag(:ul, :class => 'inputs-list') do
          fields.map do |field|
            content_tag(:li, :class => 'inline') do
              (field[:value] == true ? hidden_field_tag(field[:name], false, :id => nil) : '') +
              check_box_tag(field[:name], field[:value], field[:checked]) +
              ' ' +
              label_tag(field[:name], field[:label])
            end
          end.join.html_safe
        end
      end
    end
  end

  def check_box_field(label, name, value, checked)
    check_box_fields(label, [{:name => name, :value => value, :checked => checked}])
  end

  def font_include_tag(*fonts)
    content_tag(:link, '', :href => "http://fonts.googleapis.com/css?family=#{fonts.join('|').sub(/\s/, '+')}", :rel => 'stylesheet', :type => 'text/css')
  end
end
