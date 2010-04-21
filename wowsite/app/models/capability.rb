class Capability < ActiveRecord::Base
  belongs_to :membercapabilities
  has_many :members, :through => :membercapabilities, :dependent => :destroy
end
