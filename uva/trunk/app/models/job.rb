class Job < ActiveRecord::Base
  attr_accessible :name, :description, :due_date, :due_time, :submit_date, :ordered_by, :auth_sig, :department_id, :account_id, :input_person, :received_date,  :workflows_attributes
  # :name_attributes, :note_attributes, :completed_attributes, :completed_date_attributes, :job_id_attributes, :workflow, :workflows,
  
  validates_presence_of :name, :due_date #, :ordered_by, :submit_date, :received_date, :description, :department_id

  has_many :workflows, :dependent => :destroy
  
  accepts_nested_attributes_for :workflows, :allow_destroy => true, :reject_if => proc { |attributes| attributes["step_needed"] == "0" } 
  
  #named_scope :not_shipped, :conditions => self.shipping.completed == false
  
  def after_save
    #params.each do |key, value|
    
    #end
  end
  
  def before_delete
    
  end
  
  def shipping
     Workflow.find(:all, :conditions => {:job_id => self, :name => 'Ship' } )
  end
end
