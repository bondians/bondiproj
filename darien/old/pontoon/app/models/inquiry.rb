class Inquiry < ActiveRecord::Base
    belongs_to :graphic_arts_person
    belongs_to :person
    belongs_to :person_phone
end
