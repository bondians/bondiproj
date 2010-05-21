class Member < ActiveRecord::Base
  belongs_to :user, :class_name =>"Goldberg::User"
  
  has_many :teammembers
  has_many :teams, :through => :teammembers
  
  has_many :membercapabilities
  has_many :capabilities, :through => :membercapabilities

  attr_accessor :capabilitiy_ids
  attr_accessor :team_ids
  
  def update_capabilities
    unless capability_ids.nil?
      self.membercapabilities.each do |m|
        m.destroy unless capability_ids.include?(m.capability_id.to_s)
        capability_ids.delete(m.capability_id.to_s)
      end 
      capability_ids.each do |g|
        self.membercapabilities.create(:capability_id => g) unless g.blank?
      end
    end
  end

  
  MEMBER_URL_PREFIX = "http://www.wowarmory.com/character-sheet.xml?"
  
  def self.unassigned
    Member.find_all_by_user_id nil, :order => :name
  end
end
