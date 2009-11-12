class Department < ActiveRecord::Base
  has_many :jobs
  has_many :accounts
end
