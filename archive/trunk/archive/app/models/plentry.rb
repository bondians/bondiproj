class Plentry < ActiveRecord::Base
  belongs_to :song
  belongs_to :playlist
end
