class Jobs < ActiveRecord::Base
  attr_accessible :name, :description, :due_date, :account_id  
  
  has_many :cardjobs
  has_many :business_card_orders, :through => :cardjobs
  
  has_many :copyjobs
  has_many :copy_orders, :through => :copyjobs
  
  belongs_to :account
  
  has_many :notes
  
  has_many :tasks
end
