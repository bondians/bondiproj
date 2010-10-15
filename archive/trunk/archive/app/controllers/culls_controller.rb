class CullsController < ApplicationController
  # GET /culls
  # GET /culls.xml
  def index
    @culls = Cull.all

    respond_to do |format|
      format.html # index.html.erb
      format.txt  #index.txt.erb
      format.xml  { render :xml => @culls }
    end
  end
end
