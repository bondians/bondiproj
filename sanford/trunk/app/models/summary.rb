class Summary < ActiveRecord::Base
  has_many :submissions
  has_many :items, :through => :submissions
end
