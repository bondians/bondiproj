class BcSchool < ActiveRecord::Base
  has_many :business_cards
  attr_accessible :name, :address, :city, :state, :zip, :default_phone, :default_fax
end
