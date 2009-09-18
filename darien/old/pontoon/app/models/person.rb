class Person < ActiveRecord::Base
    belongs_to :department
    has_many :person_phones
    has_many :phones , :through => :person_phones
end
