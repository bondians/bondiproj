class SongType < ActiveRecord::Base
  has_many :songs
end
