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

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @cull = Cull.find(params[:id])
    @cull.destroy
    respond_to do |format|
      format.html { redirect_to(culls_url) }
      format.xml  { head :ok }
    end
  end
  
end
