class Task < ActiveRecord::Base
  attr_accessible :name, :note, :completed, :completed_date, :job_id, \
    :step_needed, :order, :task_type_id, :item_cost, :type_name, :billable_minutes 
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
  
  def self.model_name
    name = "task"
    name.instance_eval do
      def plural; pluralize; end
      def singular; singularize; end
    end
    return name
  end
  
  private
  def set_current_step_of_parent_job

    steps = Task.find_all_by_job_id(self.job_id).sort { |a, b| (a.order || 1) <=> (b.order || 1) }

    #completed = lambda { self.completed = true; nil }
    curstep = steps.detect { |i| i.completed != true }
    curjob = Job.find(self.job_id)
    if curstep == nil then
      curjob.task_id = self.id # rather than leaving a hanging nil,
                    # set the job.task to self (the calling task step)
      curjob.completed = true
      curjob.task_type_id = Task_type.find_by_name("Complete")
      curjob.save

    else
      curjob.task_id = curstep.id
      curjob.task_type_id = curstep.task_type_id
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
