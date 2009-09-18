class Department < ActiveRecord::Base
    has_many :people
    has_many :inquiries
end
