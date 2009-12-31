class Workflow < ActiveRecord::Base
  attr_accessible :name, :note, :completed, :completed_date, :job_id, :step_needed, :order 
  belongs_to :job #, :dependent => :destroy
  has_one :job
  validates_presence_of :name 
  
  after_save :set_current_step_of_parent_job
  #after_create :phony_after_create
  
  named_scope :unshipped, :conditions => {:name => 'Ship', :completed => false }
  named_scope :newunshipped, :conditions => {:name => 'Ship', :completed => nil }
  named_scope :shipped, :conditions => {:name => 'Ship', :completed =>  true }
  
  def complete_step
    self.completed = true
    self.completed_date = Time.now
    self.save
  end
  
  private
  def set_current_step_of_parent_job

    steps = Workflow.find_all_by_job_id(self.job_id).sort { |a, b| (a.order || 1) <=> (b.order || 1) }

    #completed = lambda { self.completed = true; nil }
    curstep = steps.detect { |i| i.completed != true }
    curjob = Job.find(self.job_id)
    if curstep == nil then
      curjob.workflow_id = nil
      curjob.completed = true
      curjob.save

    else
      curjob.workflow_id = curstep.id
      curjob.completed = false
      curjob.save
   end 
   
 #  self.completed = true
 #  self.completed_date = Date.today 
 #  self.save
  end
  
  def <=> (other)
    self.order <=> other.order
  end
  
end
