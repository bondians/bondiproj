class BusinessCardBatch < ActiveRecord::Base
  has_many :business_card_orders
  has_many :business_cards, :through => :business_card_order
  
  attr_accessible :quantity, :printed, :batch_name
  
  
  
  
  
end
