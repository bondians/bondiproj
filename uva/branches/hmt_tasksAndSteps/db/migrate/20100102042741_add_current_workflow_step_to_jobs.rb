class AddCurrentWorkflowStepToJobs < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.remove :note
      t.remove :completed
      t.remove :completed_date
      t.remove :job_id
    end

    Task.create :name => "Complete"
    Task.create :name => "Design"
    Task.create :name => "Copy"
    Task.create :name => "Press"
    Task.create :name => "Bindery"
    Task.create :name => "Ship"
    Task.create :name => "Other"
    
    add_column :jobs, :task_id, :integer

    Job.reset_column_information
    Task.reset_column_information

    Job.all.each do |m|
      
     k = m.workflow_id.nil? ? "Complete" : Workflow.find(m.workflow_id).name
      
     puts k
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
    remove_column :jobs, :task_id
    
    add_column :tasks, :note, :string
    add_column :tasks, :completed, :boolean
    add_column :tasks, :completed_date, :date
    add_column :tasks, :job_id, :integer
    
  end
end
