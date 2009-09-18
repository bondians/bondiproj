class PTypesKindBadNeedBigFix < ActiveRecord::Migration
  def self.up
      change_table :phone_types do |t|
         t.remove :kind
         t.string :phkind 
      end
  end

  def self.down
      change_table :phone_types do |t|
         t.remove :phkind
         t.string :kind 
      end
  end
end
