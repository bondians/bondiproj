class Workflow < ActiveRecord::Base
  attr_accessible :name, :note, :completed, :completed_date, :job_id, :step_needed 
  belongs_to :job #, :dependent => :destroy
  validates_presence_of :name 
  
  named_scope :unshipped, :conditions => {:name => 'Ship', :completed => nil || false }
  named_scope :shipped, :conditions => {:name => 'Ship', :completed =>  true }
end
