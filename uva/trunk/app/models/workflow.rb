class Workflow < ActiveRecord::Base
  attr_accessible :name, :note, :completed, :completed_date, :job_id 
  belongs_to :job, :dependent => :destroy
  validates_presence_of :name
end
