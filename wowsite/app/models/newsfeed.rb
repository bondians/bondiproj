class Newsfeed < ActiveRecord::Base
  has_many :newsitems, :order => "created_at DESC"
end
