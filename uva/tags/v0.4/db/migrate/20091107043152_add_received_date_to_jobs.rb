class AddReceivedDateToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :received_date, :date
  end
  def self.down
    remove_column :jobs, :received_date
  end
end
