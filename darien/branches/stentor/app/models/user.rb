class User < ActiveRecord::Base
  acts_as_authentic
  # Ryan Bates doesn't have this stuff
  # attr_accessible :username, :email, :password
end
