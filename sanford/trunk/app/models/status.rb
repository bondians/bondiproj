class Status < ActiveRecord::Base
  has_many :submissions
end
