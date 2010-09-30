class Plentry < ActiveRecord::Base
  belongs_to :song
  belongs_to :playlist
  
  def <=> (other)
    idx.to_i <=> other.idx.to_i
  end
  
end
