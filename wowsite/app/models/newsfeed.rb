class Newsfeed < ActiveRecord::Base
  has_many :newsitems
end
