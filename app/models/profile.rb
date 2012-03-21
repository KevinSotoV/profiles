class Profile < ActiveRecord::Base

  include Workflow
  workflow do
    state :visible do
      event :hide, :transitions_to => :hidden
    end
    state :hidden do
      event :show, :transitions_to => :visible
    end
  end

  belongs_to :user
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :messages
  has_many :roles
  has_many :groups, :through => :roles

  scope :visible, where(:workflow_state => 'visible')
  scope :visible_or_user, lambda { |user| where('workflow_state = ? or user_id = ?', 'visible', user) }

  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  validates_length_of :headline, :maximum => 50
  validates_inclusion_of :gender, :in => %w(m f), :allow_nil => true
  validates_length_of :location, :maximum => 50
  validates_length_of :phone, :maximum => 50
  validates_presence_of :user_id
  validates_uniqueness_of :user_id

  attr_accessible :name, :headline, :bio, :gender, :birthday, :member_since, :location, :phone, :facebook_id, :facebook_url, :small_image_url, :full_image_url, :alerts

  delegate :email, :to => :user

  blank_to_nil

  before_save :set_image_urls

  def set_image_urls
    base = "http://www.gravatar.com/avatar/#{user.gravatar_hash}"
    self.small_image_url ||= "#{base}?s=50"
    self.full_image_url  ||= "#{base}?s=180"
  end

  # alerts
  bitmask :alerts, :as => [:new]
  before_create { alerts << :new }

  # FIXME this is hacky
  def gender=(g)
    g = nil if g == 'nil'
    write_attribute(:gender, g)
  end

  def bio=(b)
    write_attribute(:bio, b.to_s[0...Setting.s('profile.bio_max_length').to_i])
  end

  def update_from_oauth!(access_token)
    data = access_token['extra']['raw_info']
    self.small_image_url = "http://graph.facebook.com/#{access_token['uid']}/picture?type=square"
    self.full_image_url  = "http://graph.facebook.com/#{access_token['uid']}/picture?type=large"
    self.gender          = {"male" => "m", "female" => "f"}[data["gender"].downcase]
    self.facebook_url    = data["link"]
    self.facebook_id     = access_token["uid"]
    self.name            = data["name"]
    self.location        = data["location"] && data["location"]["name"]
    self.phone           = data["phone"] if data["phone"]
    save!
  end

  # should only be called when the user is logged in
  # (effectively self.user is expected to be the current_user with an updated fb_token)
  def update_friends!
    ids = user.graph.friends.map(&:identifier)
    profiles = User.includes(:profile).where(
      'users.provider'          => 'facebook',
      'users.uid'               => ids,
      'profiles.workflow_state' => 'visible'
    ).map(&:profile)
    self.friends = profiles
  end

  def next_birthday
    if birthday
      d = birthday
      d = Date.new(d.year + 1, d.month, d.day) until d >= Date.today
      return d
    end
  end

  after_create :new_profile_notification
  def new_profile_notification
    AdminMailer.new_profile_notifications
  end
end
