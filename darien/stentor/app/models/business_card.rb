class BusinessCard < ActiveRecord::Base
  belongs_to :bc_school
  has_many :business_card_orders
  has_many :business_card_batches, :through => :business_card_order
  
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  attr_accessible :name, :title, :title_line_2, :school, :school_line_2, :address, :city, :state, :zip, :phone, :fax, :email, :extra, :altEd, :distinguished_school, :ordered
end
