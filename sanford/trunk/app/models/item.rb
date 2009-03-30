class Item < ActiveRecord::Base
  belongs_to :condition
  belongs_to :request
end
