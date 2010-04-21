class Team < ActiveRecord::Base
  belongs_to :teammembers
  has_many :members, :through => :teammembers
end
