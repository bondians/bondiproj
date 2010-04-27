class Usertime < ActiveRecord::Base
  belongs_to :user, :class_name =>"Goldberg::User"
end
