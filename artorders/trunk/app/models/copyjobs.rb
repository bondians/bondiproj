class Copyjobs < ActiveRecord::Base 
  belongs_to :job
  belongs_to :copy_order
end
