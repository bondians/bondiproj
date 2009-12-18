class Segue < ActiveRecord::Base
  belongs_to :song
  belongs_to :segue_to, :class_name => "Song", :foreign_key => "segue_to_id"
end
