class Bindery < Task
  # inherited from Task
  # attr_accessible :name, :note, :completed, :completed_date, 
  #   :job_id, :step_needed, :order, :task_type_id, :item_cost, 
  #   :type_name, :billable_minutes 
  attr_accessible :bindery_description, :bindery_billable_minutes, \
  :bindery_charge_by_minutes, :bindery_hole_punch, :bindery_paper_band, \
  :bindery_laminate, :bindery_pad, :bindery_sheets_per_pad, :bindery_cut, \
  :bindery_score, :bindery_fold, :bindery_staple, :bindery_bind, \
  :bindery_bind_style
end
