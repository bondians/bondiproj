class Person < ActiveRecord::Base
    belongs_to :department
    has_many :persiphones  # asking cayuse about this one
    has_many :phones, :through => :persiphones
end
