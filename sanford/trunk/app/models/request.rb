class Request < ActiveRecord::Base
  belongs_to :user, :class_name=>"Goldberg::User", :foreign_key=>:user_id
  belongs_to :status
  belongs_to :summary
  
  has_many :items
  accepts_nested_attributes_for :items, :allow_destroy => true
end
