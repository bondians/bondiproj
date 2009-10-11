class CreateCopyjobs < ActiveRecord::Migration
  def self.up
    create_table :copyjobs do |t|
      t.integer :job_id
      t.integer :copy_order_id
      t.timestamps
    end
  end

  def self.down
    drop_table :copyjobs
  end
end
