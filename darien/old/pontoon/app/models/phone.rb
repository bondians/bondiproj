class Phone < ActiveRecord::Base
    belongs_to :phone_type
    has_many :person_phones
    has_many :people, :through => :person_phones
end
