class PrepareForSubtasks < ActiveRecord::Migration
  def self.up
    add_column :departments, :short_name, :string, :limit => 6
    
    add_column :jobs, :tasks_list_formatted, :text
    add_column :jobs, :completed_date, :date

    Job.reset_column_information
    Department.reset_column_information
    Task.reset_column_information

    Job.all.each do |m|
      if m.completed?
        m.completed_date = Task.find_all_by_job_id(m.id).sort { |a, b| a.completed_date <=> b.completed_date }.last.completed_date
        m.save
      end
    end
    
    Department.all.each do |d|
      d.short_name = d.name.slice(0..4).gsub(/ /, '')
      d.save
    end

  end

  def self.down
    remove_column :jobs, :tasks_list_formatted
    remove_column :jobs, :completed_date
    
    remove_column :departments, :short_name
  end
end
