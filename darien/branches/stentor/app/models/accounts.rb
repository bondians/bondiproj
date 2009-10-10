class Accounts < ActiveRecord::Base
  attr_accessible :account_number, :department_id, :name
  
  has_many :jobs
  
  belongs_to :department
end
