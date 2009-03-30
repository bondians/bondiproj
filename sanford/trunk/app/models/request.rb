class Request < ActiveRecord::Base
  belongs_to :goldberg_user
  belongs_to :status
  belongs_to :summary
  
  has_many :items
  accepts_nested_attributes_for :items, :allow_destroy => true
end
