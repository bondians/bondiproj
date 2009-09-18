class Inquiry < ActiveRecord::Base
    belongs_to :artist_recipient, :class_name => 'Artist'
    belongs_to :artist_notater, :class_name => 'Artist'
    belongs_to :person
    belongs_to :department
    belongs_to :persiphone
end
