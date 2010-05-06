class Team < ActiveRecord::Base
  has_many :teammembers
  has_many :members, :through => :teammembers
  
  validates_presence_of :number
  validates_presence_of :identity
  
  after_save :save_member_collections
  
  def self.not_on_team(team)
    (Member.all :order => :name) - team.members
  end
  
  
  def member_ids=(member_ids)
    @new_member_ids = member_ids
  end
  
  def save_member_collections
    if @new_member_ids
      teammembers.each do |teammember|
        teammember.destroy unless @new_member_ids.include? teammember.member_id
      end
      
      @new_member_ids.each do |id|
        self.teammembers.create(:member_id => id) unless teammembers.any? { |d| d.member_id == id }
      end
    else
      teammembers.clear
    end
  end
  
  
end
