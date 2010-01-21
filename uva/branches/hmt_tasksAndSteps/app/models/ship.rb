class Ship < Task
  # inherited from Task
  # attr_accessible :name, :note, :completed, :completed_date, 
  #   :job_id, :step_needed, :order, :task_type_id, :item_cost, 
  #   :type_name, :billable_minutes 
  attr_accessible :ship_method_id, :ship_call_when_ready, :ship_phone_number
  
end
