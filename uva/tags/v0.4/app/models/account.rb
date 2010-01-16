class Account < ActiveRecord::Base
  has_many :jobs
  belongs_to :department
end
