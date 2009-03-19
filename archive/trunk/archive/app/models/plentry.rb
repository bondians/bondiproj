class Plentry < ActiveRecord::Base
  belongs_to :song
  belongs_to :playlist
  
  def <=> (other)
    idx <=> other.idx
  end
  
end
