class Reqlist < ActiveRecord::Base
  belongs_to :song
  
  def self.set_index(new_index)
    new_index.each_with_index{|entry,i| Reqlist.update_all(["sort = ?", i], ["id = ?", entry])}
  end
end
