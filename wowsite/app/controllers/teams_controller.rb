class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.all :include => :members

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @capabilities = Capability.all
    @team = Team.new
    @unused = Member.all :include => :capabilities

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @capabilities = Capability.all
    @team = Team.find params[:id], :include => :members
    @unused = Team.not_on_team(@team)
  end

  # POST /teams
  # POST /teams.xml
  def create
    params[:team][:member_ids] ||= []
    @team = Team.new(params[:team])
    
    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to '/teams' }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        #@unused = (Member.all - Member.find(params[:team][:member_ids]))
        @unused = Member.all
        @capabilities = Capability.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    #params[:member_ids]
    @team = Team.find params[:id], :include => :members

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to '/teams' }
        format.xml  { head :ok }
      else
        @capabilities = Capability.all
        @unused = Team.not_on_team(@team)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
      format.xml  { head :ok }
    end
  end
end
