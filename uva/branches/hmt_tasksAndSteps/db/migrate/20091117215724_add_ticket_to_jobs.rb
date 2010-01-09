class AddTicketToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :ticket, :string
  end

  def self.down
    remove_column :jobs, :ticket
  end
end
