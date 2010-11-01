class ApidsController < ApplicationController
  def index
    @apids = Apid.all :order => :id
  end
  def update
    if (params[:apid] && params[:apid]["apid_ids"])
      active =  params[:apid]["apid_ids"].collect{|a| a.to_i}
    else
      active = []
    end
    
    apids = Apid.all
    apids.each do |list|
      active.include?(list.id) ? list.active = true : list.active = false
      list.save
    end
    flash[:notice] = "apids succesfully updated"
    redirect_to apids_url
  end
end
