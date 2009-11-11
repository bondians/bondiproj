class Job < ActiveRecord::Base
  attr_accessible :name, :description, :due_date, :due_time, :submit_date, :ordered_by, :auth_sig, :department_id, :account_id, :input_person, :received_date,  :workflows_attributes
  # :name_attributes, :note_attributes, :completed_attributes, :completed_date_attributes, :job_id_attributes, :workflow, :workflows,
  
  validates_presence_of :name #, :ordered_by, :due_date, :submit_date, :received_date, :description, :department_id

  has_many :workflows, :dependent => :destroy
  
  accepts_nested_attributes_for :workflows, :allow_destroy => true, :reject_if => proc { |attributes| attributes["step_needed"] == "0" } 
  
  def after_save
    #params.each do |key, value|
    
    #end
  end
  
  def before_delete
    
  end
end
