class PersonPhonesController < ApplicationController
  # GET /person_phones
  # GET /person_phones.xml
  def index
    @person_phones = PersonPhone.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_phones }
    end
  end

  # GET /person_phones/1
  # GET /person_phones/1.xml
  def show
    @person_phone = PersonPhone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person_phone }
    end
  end

  # GET /person_phones/new
  # GET /person_phones/new.xml
  def new
    @person_phone = PersonPhone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person_phone }
    end
  end

  # GET /person_phones/1/edit
  def edit
    @person_phone = PersonPhone.find(params[:id])
  end

  # POST /person_phones
  # POST /person_phones.xml
  def create
    @person_phone = PersonPhone.new(params[:person_phone])

    respond_to do |format|
      if @person_phone.save
        flash[:notice] = 'PersonPhone was successfully created.'
        format.html { redirect_to(@person_phone) }
        format.xml  { render :xml => @person_phone, :status => :created, :location => @person_phone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person_phone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_phones/1
  # PUT /person_phones/1.xml
  def update
    @person_phone = PersonPhone.find(params[:id])

    respond_to do |format|
      if @person_phone.update_attributes(params[:person_phone])
        flash[:notice] = 'PersonPhone was successfully updated.'
        format.html { redirect_to(@person_phone) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person_phone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_phones/1
  # DELETE /person_phones/1.xml
  def destroy
    @person_phone = PersonPhone.find(params[:id])
    @person_phone.destroy

    respond_to do |format|
      format.html { redirect_to(person_phones_url) }
      format.xml  { head :ok }
    end
  end
end
