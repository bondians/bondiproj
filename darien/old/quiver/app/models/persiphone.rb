class Persiphone < ActiveRecord::Base
    belongs_to :person
    belongs_to :phone
    has_many :inquiries
end
