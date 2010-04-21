class Member < ActiveRecord::Base
  belongs_to :user, :class_name =>"Goldberg::User"
  
  belongs_to :teammembers
  has_many :teams, :through => :teammembers
  
  belongs_to :membercapabilities
  has_many :capabilities, :through => :membercapabilities
  
  MEMBER_URL_PREFIX = "http://www.wowarmory.com/character-sheet.xml?"
  
  def self.unassigned
    Member.find_all_by_user_id nil
  end
end
