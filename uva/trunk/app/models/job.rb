class Job < ActiveRecord::Base
  has_many :workflows, :dependent => :destroy
  belongs_to :department
  belongs_to :account
  belongs_to :workflow
 
 # after_save :set_current_workflow_step
  
  attr_accessible :name, :ticket, :description, :due_date, :due_time, :submit_date, :ordered_by, :auth_sig, :department_id, :account_id, :input_person, :received_date, :workflow_id, :completed, :workflows_attributes #,
   
  validates_presence_of :name, :due_date #, :ordered_by, :submit_date, :received_date, :description, :department_id

  #:department_attributes
    # :name_attributes, :note_attributes, :completed_attributes, :completed_date_attributes, :job_id_attributes, :workflow, :workflows,

    accepts_nested_attributes_for :workflows, :allow_destroy => true, :reject_if => proc { |attributes| attributes["step_needed"] == "0" }

# thinking sphinx 
  define_index do
    indexes [name, description, ticket], :as => :description
    # indexes description #], :as => :name
    indexes ordered_by, :as => :customer
    indexes workflows.note, :as => :workflow_note #added
   indexes workflow.name, :as => :current_workflow
   indexes department.name, :as => :department

   has due_date, completed
    
   # indexes workflow.name, :as => :workflow_name #added
    
  end
 # accepts_nested_attributes_for :department #, :allow_destroy => false #, :reject_if => proc { |attributes| attributes["step_needed"] == "0" } 
  
  #named_scope :not_shipped, lambda { { :job => self, :name => 'Ship', :completed => false}}
  public


  def not_shipped
     Workflow.find(:all, :conditions => {"job_id = ?" => self, "name = ?" => "Ship", "completed = ? " => false } )
  end


#   def department_name
#     department.name if department
#   end
#  
#  def department_name=(name)
#    self.department = Department.find_or_create_by_name(name) unless name.blank?
#  end
#  
  def workflow_steps_simple
    # this is a read-only display of workflow steps needed or completed
    # D - C - P - B - S
    # maybe it'll contain a id of the related item
    steps = Workflow.find_all_by_job_id(self).sort { |a, b| (a.order || 1) <=> (b.order || 1) } 
    
    #puts steps.class
  end
  
  
 # private
  
#  def set_current_workflow_step
#    steps = Workflow.find_all_by_job_id(self).sort { |a, b| (a.order || 1) <=> (b.order || 1) }
#    
#    #completed = lambda { self.completed = true; nil }
#    curstep = steps.detect { |i| i.completed != true }
#    self.workflow_id = curstep.id
#    #self.save
#    puts "*************** SET current workflow step called "
#  end
  
end


