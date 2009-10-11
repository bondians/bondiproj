class Cardjobs < ActiveRecord::Base
  belongs_to :job
  belongs_to :business_card_order
end
