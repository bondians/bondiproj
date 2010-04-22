class Membercapability < ActiveRecord::Base
  belongs_to :member
  belongs_to :capability
end
