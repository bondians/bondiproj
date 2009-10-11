class SurplusItems < ActiveRecord::Base
  belongs_to :oversupply
  attr_accessible :description, :make_model, :inventory_id_tag_number, :quantity, :condition_code , :oversupply_id
end
