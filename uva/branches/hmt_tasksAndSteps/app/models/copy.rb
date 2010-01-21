class Copy < Task
  # inherited from Task
  # attr_accessible :name, :note, :completed, :completed_date, 
  #   :job_id, :step_needed, :order, :task_type_id, :item_cost, 
  #   :type_name, :billable_minutes 
  attr_accessible :copy_description, :copy_machine, :copy_originals_quantity, \
   :copy_copies_quantity, :copy_tab_dividers, :copy_tab_dividers_count, \
   :paper_color_id, :paper_size_id, :card_stock_color_id, :copier_staple, \
   :copier_staple_type_id, :copier_bind, :copier_bind_type_id, :copier_fold, \
   :copier_fold_type_id, :copier_collate
end
