class UpdateTasksForSingeTableInheritenceRefactor < ActiveRecord::Migration
  def self.up
    add_column :tasks, :item_cost, :decimal, :precision => 12, :scale => 5
    add_column :tasks, :type_name, :string, :limit => 15
    add_column :tasks, :type, :string
    add_column :tasks, :billable_minutes, :integer

    # Design
    add_column :tasks, :design_description, :string
    add_column :tasks, :design_charge_by_minutes, :boolean
    add_column :tasks, :design_path_on_server, :string
    
    # Copy
    add_column :tasks, :copy_description, :string
    add_column :tasks, :copy_machine, :string
    add_column :tasks, :copy_originals_quantity, :integer
    add_column :tasks, :copy_copies_quantity, :integer
    add_column :tasks, :copy_tab_dividers, :boolean
    add_column :tasks, :copy_tab_dividers_count, :integer
    add_column :tasks, :paper_color_id, :integer
    add_column :tasks, :paper_size_id, :integer
    add_column :tasks, :card_stock_color_id, :integer
    add_column :tasks, :copier_staple, :boolean
    add_column :tasks, :copier_staple_type_id, :integer
    add_column :tasks, :copier_bind, :boolean
    add_column :tasks, :copier_bind_type_id, :integer
    add_column :tasks, :copier_fold, :boolean
    add_column :tasks, :copier_fold_type_id, :integer
    add_column :tasks, :copier_collate, :boolean
    
    # Press
    add_column :tasks, :press_description, :string
    add_column :tasks, :press_ink_colors, :string
    
    # Bindery
    add_column :tasks, :bindery_description, :string
    add_column :tasks, :bindery_billable_minutes, :integer
    add_column :tasks, :bindery_charge_by_minutes, :boolean
    add_column :tasks, :bindery_hole_punch, :boolean
    add_column :tasks, :bindery_paper_band, :boolean
    add_column :tasks, :bindery_laminate, :boolean
    add_column :tasks, :bindery_pad, :boolean
    add_column :tasks, :bindery_sheets_per_pad, :integer
    add_column :tasks, :bindery_cut, :boolean
    add_column :tasks, :bindery_score, :boolean
    add_column :tasks, :bindery_fold, :boolean
    add_column :tasks, :bindery_staple, :boolean
    add_column :tasks, :bindery_bind, :boolean
    add_column :tasks, :bindery_bind_style, :string
    
    # Ship
    add_column :tasks, :ship_method_id, :integer
    add_column :tasks, :ship_call_when_ready, :boolean
    add_column :tasks, :ship_phone_number, :string
    
    # Price
    add_column :tasks, :price_description, :string
    add_column :tasks, :price_flat_rate, :integer
    add_column :tasks, :price_use_flat_rate, :boolean
    
    # Accounting
    add_column :tasks, :accounting_description, :string
    add_column :tasks, :accounting_batch, :integer
    
    


  end

  def self.down
    remove_column :tasks, :item_cost
    remove_column :tasks, :type_name
    remove_column :tasks, :type
    remove_column :tasks, :billable_minutes

    # Design
    remove_column :tasks, :design_description
    remove_column :tasks, :design_charge_by_minutes
    remove_column :tasks, :design_path_on_server
    
    # Copy
    remove_column :tasks, :copy_description
    remove_column :tasks, :copy_machine
    remove_column :tasks, :copy_originals_quantity
    remove_column :tasks, :copy_copies_quantity
    remove_column :tasks, :copy_tab_dividers
    remove_column :tasks, :copy_tab_dividers_count
    remove_column :tasks, :paper_color_id
    remove_column :tasks, :paper_size_id
    remove_column :tasks, :card_stock_color_id
    remove_column :tasks, :copier_staple
    remove_column :tasks, :copier_staple_type_id
    remove_column :tasks, :copier_bind
    remove_column :tasks, :copier_bind_type_id
    remove_column :tasks, :copier_fold
    remove_column :tasks, :copier_fold_type_id
    remove_column :tasks, :copier_collate
    
    # Press
    remove_column :tasks, :press_description
    remove_column :tasks, :press_ink_colors
    
    # Bindery
    remove_column :tasks, :bindery_description
    remove_column :tasks, :bindery_billable_minutes
    remove_column :tasks, :bindery_charge_by_minutes
    remove_column :tasks, :bindery_hole_punch
    remove_column :tasks, :bindery_paper_band
    remove_column :tasks, :bindery_laminate
    remove_column :tasks, :bindery_pad
    remove_column :tasks, :bindery_sheets_per_pad
    remove_column :tasks, :bindery_cut
    remove_column :tasks, :bindery_score
    remove_column :tasks, :bindery_fold
    remove_column :tasks, :bindery_staple
    remove_column :tasks, :bindery_bind
    remove_column :tasks, :bindery_bind_style
    
    # Ship
    remove_column :tasks, :ship_method_id
    remove_column :tasks, :ship_call_when_ready
    remove_column :tasks, :ship_phone_number
    
    # Price
    remove_column :tasks, :price_description
    remove_column :tasks, :price_flat_rate
    remove_column :tasks, :price_use_flat_rate
    
    # Accounting
    remove_column :tasks, :accounting_description
    remove_column :tasks, :accounting_batch
  end
end
