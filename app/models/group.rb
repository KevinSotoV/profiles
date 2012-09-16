class Group < ActiveRecord::Base
  has_many :roles
  has_many :profiles, :through => :roles
end
