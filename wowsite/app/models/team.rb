class Team < ActiveRecord::Base
  has_many :teammembers
  has_many :members, :through => :teammembers
end
