class BusinessCardOrder < ActiveRecord::Base
  belongs_to :business_card
  belongs_to :buiness_card_batch
  
  attr_accessible :quantity, :business_card_batch_id, :reprint, :business_card_id

  validates_numericality_of :quantity, :on => :create
  validates_presence_of :quantity, :on => :create
  
  def business_card_name
    business_card.name if business_card 
  end
  
  def business_card_name=(name)
    self.business_card = BusinessCard.find_by_name(name) unless name.blank?
    # Ryan Bates does find_or_create_by_name but it doesn't work for me
  end
  
end
