class Member < ActiveRecord::Base
  belongs_to :user, :class_name =>"Goldberg::User"
  MEMBER_URL_PREFIX = "http://www.wowarmory.com/character-sheet.xml?"
  
  def self.unassigned
    Member.find_all_by_ 
  end
end
