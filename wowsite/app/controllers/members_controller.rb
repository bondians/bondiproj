class MembersController < ApplicationController
  # GET /members
  # GET /members.xml
  def index
    #@members = Member.all
    @members = Member.all :order => order_with_default("name", "asc")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end
  
  def myindex
    @title = "Listing Your Toons"
    @members = Goldberg.user.members :include => :capabilities
    @capabilities = Capability.all
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
  end

  # GET /members/1/edit
  def edit
    @capabilities = Capability.all
    member = Member.find params[:id], :include => :capabilities
    @cap = Capability.find params[:with][:cap]
    unless member.capabilities.exists? @cap
      member.membercapabilities.create(:capability_id => @cap.id)
    else
      member.membercapabilities.each do |memcap|
        memcap.destroy if memcap.capability_id == @cap.id
      end
    end
    @member = Member.find params[:id], :include => :capabilities
    respond_to do |format|
      format.js
    end
    
  end

  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        flash[:notice] = 'Member was successfully created.'
        format.html { redirect_to(@member) }
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to '/members/myindex' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end

private

  def order_with_default(column, direction)
    if params[:sort]
      "#{params[:sort]} #{params[:direction]}"
    else
      "#{column} #{direction}"
    end
  end
end
