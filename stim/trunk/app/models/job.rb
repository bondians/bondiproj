class Job < ActiveRecord::Base
  attr_accessible :name, :description, :submit_date, :due_date, :entry_person, :acct_number, :requester, :department, :auth_sig, :uno_path, :copier_name 
  
  has_many :simple_tasks
end
