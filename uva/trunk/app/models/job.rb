class Job < ActiveRecord::Base
  attr_accessible :name, :description, :due_date, :due_time, :submit_date, :ordered_by, :auth_sig, :department_id, :account_id, :input_person, :received_date, :name_attributes, :note_attributes, :completed_attributes, :completed_date_attributes, :job_id_attributes, :workflow, :workflows, :workflows_attributes
  
  validates_presence_of :name #, :ordered_by, :due_date, :submit_date, :received_date, :description, :department_id

  has_many :workflows
  
  accepts_nested_attributes_for :workflows, :allow_destroy => true 
  
  def after_save
    #params.each do |key, value|
    
    #end
  end
end
