class Notes < ActiveRecord::Base
  attr_accessible :name, :description, :job_id 
  
  belongs_to :job
end
