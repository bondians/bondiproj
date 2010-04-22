class Capability < ActiveRecord::Base
  has_many :membercapabilities
  has_many :members, :through => :membercapabilities, :dependent => :destroy
end
