class Theme < ActiveRecord::Base

  VALID_BOX_POSITIONS = %w(left right)

  belongs_to :profile

  validates_presence_of :box_pos,              :box_bg_color,  :box_bg_opacity,
                        :name_font_family,     :name_size,     :name_color,
                        :headline_font_family, :headline_size, :headline_color,
                        :bio_font_family,      :bio_size,      :bio_color

  validates_inclusion_of :box_pos, :in => VALID_BOX_POSITIONS
  validates_inclusion_of :name_size, :headline_size, :bio_size, :in => 10..32
  validates_inclusion_of :name_size, :headline_size, :bio_size, :in => 10..32
  validates_format_of :box_bg_color, :name_color, :headline_color, :bio_color, :bg_color_top, :bg_color_bottom,
                      :with => /^#[0-9a-f]{3}[0-9a-f]{3}?$/, :allow_nil => true

  attr_protected :profile_id, :created_at, :updated_at

  after_create                   { profile.new_theme_alert!        }
  after_update(:if => :changed?) { profile.new_theme_alert!(false) }

  blank_to_nil

  # filename or info hash
  def bg_image=(filename)
    if filename.to_s.blank?
      info = {}
    elsif filename.is_a?(String)
      info = self.class.backgrounds_by_filename[filename] 
    else
      info = filename
    end
    write_attribute(:bg_image, info['filename'])
    self.bg_image_name   = info['name']
    self.bg_image_byline = info['credit'].to_s + (info['license-short'] ? " (#{info['license-short']})" : '')
    self.bg_image_tiled  = info['format'] == 'tiled'
    self.bg_class        = info['class']
  end

  def bg_color_top=(color)
    write_attribute(:bg_color_top, color)
    self.bg_class = 'light' unless color.to_s.blank?
  end

  class << self
    extend ActiveSupport::Memoizable

    def build_with_defaults(bg_class=nil)
      theme = Theme.new(
        :box_bg_color         => bg_class == 'dark' ? '#fff' : '#000',
        :box_bg_opacity       => 0.5,
        :name_font_family     => 'Handlee',
        :name_size            => 28,
        :name_color           => '#fff',
        :headline_font_family => 'Handlee',
        :headline_font_style  => 'italic',
        :headline_size        => 16,
        :headline_color       => '#fff',
        :bio_font_family      => 'Ubuntu',
        :bio_size             => 12,
        :bio_color            => '#fff'
      )
    end

    def build_random
      if 'color' == %w(color image).sample
        build_random_color
      else
        build_from_image_info(backgrounds[:tiled].sample)
      end
    end

    def build_random_color
      build_with_defaults.tap do |theme|
        # fairly light and hue <= 220 (no purple or pink)
        color = random_sass_hsl_color(rand(1..220), rand(20..60), rand(50..90))
        theme.bg_color_top = color.to_s
        theme.bg_class     = 'light'
        theme.box_pos      = VALID_BOX_POSITIONS.sample
      end
    end

    def random_sass_hsl_color(h, s, l)
      context = Sass::Script::Functions::EvaluationContext.new({})
      context.hsl(
        Sass::Script::Number.new(h),
        Sass::Script::Number.new(s),
        Sass::Script::Number.new(l)
      ).tap do |color|
        color.options = {}
      end
    end

    def build_from_image_info(info)
      build_with_defaults(info['class']).tap do |theme|
        theme.bg_image = info
        theme.box_pos  = info['box_pos']
      end
    end

    def image_info
      YAML::load_file(Rails.root.join('app/assets/images/bg/info.yml'))
    end

    memoize :image_info

    def backgrounds
      {
        :scaled => image_info.select { |bg| bg['format'] != 'tiled' },
        :tiled  => image_info.select { |bg| bg['format'] == 'tiled' }
      }
    end

    def backgrounds_by_filename
      image_info.inject({}) { |h, bg| h[bg['filename']] = bg; h }
    end
  end
end
