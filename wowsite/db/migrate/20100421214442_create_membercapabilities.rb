class CreateMembercapabilities < ActiveRecord::Migration
  def self.up
    create_table :membercapabilities do |t|
      t.references :member
      t.references :capability

      t.timestamps
    end
  end

  def self.down
    drop_table :membercapabilities
  end
end
