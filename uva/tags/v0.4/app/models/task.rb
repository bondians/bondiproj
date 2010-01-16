class Task < ActiveRecord::Base
  attr_accessible :name 
  has_many :jobs
  has_many :workflows
end
