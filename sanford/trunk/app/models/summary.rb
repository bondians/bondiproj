class Summary < ActiveRecord::Base
  has_many :requests
  has_many :items, :through => :requests
end
