class SubmissionsController < ApplicationController

  def index
    if Goldberg.user.role.cache[:credentials].permission_ids.include?(6)
      @submissions = Submission.all
    else
      @submissions = Submission.user
    end
  end

  def show
    @submission = Submission.find(params[:id])
    unless Goldberg.user.role.cache[:credentials].permission_ids.include?(6) || Goldberg.user == @submission.user
      flash[:error] = "You Cannot View this submission."
      redirect_to(submissions_url)
    end
  end

  def new
    @submission = Submission.new
    @submission.user = Goldberg.user
  end

  def edit
    @submission = Submission.find(params[:id])
    unless Goldberg.user.role.cache[:credentials].permission_ids.include?(6) || Goldberg.user == @submission.user
      flash[:error] = "You cannot Edit this submission."
      redirect_to(submissions_url)
    end
  end

  def create
    @submission = Submission.new(params[:submission])
    @submission.user = Goldberg.user

    if @submission.save
      flash[:notice] = 'Submission was successfully created.'
      redirect_to(@submission)
    else
      render :action => "new"
    end
  end

  def update
    params[:submission][:existing_item_attributes] ||= {}
    @submission = Submission.find(params[:id])

    if @submission.update_attributes(params[:submission])
      flash[:notice] = 'Submission was successfully updated.'
      redirect_to(@submission)
    else
      render :action => "edit"
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy
    redirect_to(submissions_url)
  end
  
end
