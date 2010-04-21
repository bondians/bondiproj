class Member < ActiveRecord::Base
  belongs_to :goldberg_user
  MEMBER_URL_PREFIX = "http://www.wowarmory.com/character-sheet.xml?"
end
