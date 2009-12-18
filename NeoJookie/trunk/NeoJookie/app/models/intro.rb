class Intro < ActiveRecord::Base
  belongs_to :song
  belongs_to :intro, :class_name => "Song", :foreign_key => "intro_id"
end
