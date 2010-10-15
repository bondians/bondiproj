class CullsController < ApplicationController
  # GET /culls
  # GET /culls.xml
  def index
    @culls = Cull.all :order => 'created_at DESC'
    @culls.each do |cull|
      cull.gone = cull.gone?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.txt  #index.txt.erb
      format.xml  { render :xml => @culls }
    end
  end
end
