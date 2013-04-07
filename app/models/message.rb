class Message < ActiveRecord::Base
  belongs_to :profile
  belongs_to :from, :class_name => 'Profile'

  validates_presence_of :profile
  validates_presence_of :from
  validates_inclusion_of :method, :in => ['mailto', 'smtp']

  attr_accessible :subject, :body
  attr_accessor :subject, :body

  after_initialize :set_method

  def set_method
    if SMTP_OK
      self.method = 'smtp'
    else
      self.method = 'mailto'
    end
  end

  after_create :send_email
  def send_email
    return unless method == 'smtp'
    MessageMailer.email(self).deliver
  end
end
