class Teammembers < ActiveRecord::Base
  belongs_to :team
  belongs_to :member
end
