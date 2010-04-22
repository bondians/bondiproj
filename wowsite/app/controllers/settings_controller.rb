class SettingsController < ApplicationController
  
  def select
    @mymembers = Goldberg.user.members
    @unused = Member.unassigned
  end
  
  def update_members
    user = Goldberg.user
    mymembers = user.members
    newmems = Member.find params[:member_ids]
    
    newmems.each do |mem|
      mem.user = user
      mem.save
    end
    
    (mymembers - newmems).each do |mem|
      mem.user_id = nil
      mem.save
    end
    redirect_to'/settings/select'
  end
  
end
