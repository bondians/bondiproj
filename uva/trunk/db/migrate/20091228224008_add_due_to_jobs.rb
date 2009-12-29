class AddDueToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :due, :datetime
    Job.reset_column_information
    Job.all.each do |m|
     datestring = String.new
     datestring << m.due_date.strftime("%Y-%m-%d")
     datestring << (m.due_time.nil? ? (" 15:30:00") : m.due_time.strftime(" %H:%M:%S"))
     m.due = DateTime.parse(datestring)
     # m.due = m.due_date.to_datetime
     # m.due = m.due_time.nil? ? 0 : m.due + ( m.due_time.min * 60 * 60 )
     # m.due = m.due_time.nil? ? 0 : m.due + ( m.due_time.hour * 60 * 60 * 60 )
      m.save
    end
    # will save the dropping until I get all the views to work again
    # remove_column :jobs, :due_date
    # remove_column :jobs, :due_time
  end

  def self.down
    remove_column :jobs, :due
  end
end
