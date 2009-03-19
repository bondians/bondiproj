class Plentry < ActiveRecord::Base
  belongs_to :song
  belongs_to :playlist
  
  def <=> (other)
    sort <=> other.sort
  end
  
end
