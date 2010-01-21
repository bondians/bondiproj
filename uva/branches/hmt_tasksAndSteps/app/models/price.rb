class Price < Task
  # inherited from Task
  # attr_accessible :name, :note, :completed, :completed_date, 
  #   :job_id, :step_needed, :order, :task_type_id, :item_cost, 
  #   :type_name, :billable_minutes 
  attr_accessible :price_description, :price_flat_rate, :price_use_flat_rate
end
