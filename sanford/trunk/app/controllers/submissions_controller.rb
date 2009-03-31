class SubmissionsController < ApplicationController
  # GET /submissions
  # GET /submissions.xml
  def index
    if Goldberg.user.role.cache[:credentials].permission_ids.include?(6)
      @submissions = Submission.all
    else
      @submissions = Submission.user
    end
  end

  # GET /submissions/1
  # GET /submissions/1.xml
  def show
    @submission = Submission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @submission }
    end
  end

  # GET /submissions/new
  # GET /submissions/new.xml
  def new
    @submission = Submission.new
    @submission.user = Goldberg.user
  end

  # GET /submissions/1/edit
  def edit
    @submission = Submission.find(params[:id])
    unless Goldberg.user.role.cache[:credentials].permission_ids.include?(6) || Goldberg.user.submissions.include?(@submission)
      flash[:error] = "You cannot edit someone elses submission"
      redirect_to(submissions_url)
    end
  end

  # POST /submissions
  # POST /submissions.xml
  def create
    @submission = Submission.new(params[:submission])
    @submission.user = Goldberg.user

    respond_to do |format|
      if @submission.save
        flash[:notice] = 'Submission was successfully created.'
        format.html { redirect_to(@submission) }
        format.xml  { render :xml => @submission, :status => :created, :location => @submission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /submissions/1
  # PUT /submissions/1.xml
  def update
    params[:submission][:existing_item_attributes] ||= {}
    @submission = Submission.find(params[:id])

    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        flash[:notice] = 'Submission was successfully updated.'
        format.html { redirect_to(@submission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.xml
  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to(submissions_url) }
      format.xml  { head :ok }
    end
  end
end
