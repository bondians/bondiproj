class Department < ActiveRecord::Base 
  attr_accessible :name
  has_many :jobs
  has_many :accounts
end
