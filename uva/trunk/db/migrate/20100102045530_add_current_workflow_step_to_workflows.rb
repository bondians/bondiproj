class AddCurrentWorkflowStepToWorkflows < ActiveRecord::Migration
  def self.up
    add_column :workflows, :task_id, :integer

    Workflow.reset_column_information
    Task.reset_column_information

    Workflow.all.each do |m|

      k = m.name

      case k
      when "Complete"
        m.task_id = Task.find_by_name("Complete").id
      when "Design"
        m.task_id = Task.find_by_name("Design").id
      when "Copy"
        m.task_id = Task.find_by_name("Copy").id
      when "Press"
        m.task_id = Task.find_by_name("Press").id
      when "Bindery"
        m.task_id = Task.find_by_name("Bindery").id
      when "Ship"
        m.task_id = Task.find_by_name("Ship").id 
      else 
        m.task_id = Task.find_by_name("Other").id
      end
      m.save
    end
  end

  def self.down
    remove_column :workflows, :task_id
  end
end
