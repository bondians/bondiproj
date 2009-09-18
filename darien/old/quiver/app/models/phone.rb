class Phone < ActiveRecord::Base
    belongs_to :phone_type
    has_many :persiphones  # asking cayuse about this one
    has_many :people, :through => :persiphones
end
