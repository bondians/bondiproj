class Job < ActiveRecord::Base
  attr_accessible :name, :description, :due_date, :due_time, :submit_date, :ordered_by, :input_person, :auth_sig, :department_id, :account_id
end
