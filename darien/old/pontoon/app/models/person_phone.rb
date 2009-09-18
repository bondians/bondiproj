class PersonPhone < ActiveRecord::Base
    belongs_to :person
    belongs_to :phone
end
