class Job < ActiveRecord::Base
  attr_accessible :name, :description, :due_date, :due_time, :submit_date, :ordered_by, :auth_sig, :department_id, :account_id, :input_person, :received_date,  :workflows_attributes, :department_attributes
  # :name_attributes, :note_attributes, :completed_attributes, :completed_date_attributes, :job_id_attributes, :workflow, :workflows,
  
  validates_presence_of :name, :due_date #, :ordered_by, :submit_date, :received_date, :description, :department_id

  has_many :workflows, :dependent => :destroy
  belongs_to :department
  belongs_to :account
  
  accepts_nested_attributes_for :workflows, :allow_destroy => true, :reject_if => proc { |attributes| attributes["step_needed"] == "0" } 

 # accepts_nested_attributes_for :department #, :allow_destroy => false #, :reject_if => proc { |attributes| attributes["step_needed"] == "0" } 
  
  #named_scope :not_shipped, lambda { { :job => self, :name => 'Ship', :completed => false}}
  
  def not_shipped
     Workflow.find(:all, :conditions => {"job_id = ?" => self, "name = ?" => "Ship", "completed = ? " => false } )
  end


  def department_name
    department.name if department
  end
  
  def department_name=(name)
    self.department = Department.find_or_create_by_name(name) unless name.blank?
  end

  def after_save
    #params.each do |key, value|
  
    #end
  end

  def before_delete
  
  end
end

