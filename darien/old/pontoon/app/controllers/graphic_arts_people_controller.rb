class GraphicArtsPeopleController < ApplicationController
  # GET /graphic_arts_people
  # GET /graphic_arts_people.xml
  def index
    @graphic_arts_people = GraphicArtsPerson.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @graphic_arts_people }
    end
  end

  # GET /graphic_arts_people/1
  # GET /graphic_arts_people/1.xml
  def show
    @graphic_arts_person = GraphicArtsPerson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @graphic_arts_person }
    end
  end

  # GET /graphic_arts_people/new
  # GET /graphic_arts_people/new.xml
  def new
    @graphic_arts_person = GraphicArtsPerson.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @graphic_arts_person }
    end
  end

  # GET /graphic_arts_people/1/edit
  def edit
    @graphic_arts_person = GraphicArtsPerson.find(params[:id])
  end

  # POST /graphic_arts_people
  # POST /graphic_arts_people.xml
  def create
    @graphic_arts_person = GraphicArtsPerson.new(params[:graphic_arts_person])

    respond_to do |format|
      if @graphic_arts_person.save
        flash[:notice] = 'GraphicArtsPerson was successfully created.'
        format.html { redirect_to(@graphic_arts_person) }
        format.xml  { render :xml => @graphic_arts_person, :status => :created, :location => @graphic_arts_person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @graphic_arts_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /graphic_arts_people/1
  # PUT /graphic_arts_people/1.xml
  def update
    @graphic_arts_person = GraphicArtsPerson.find(params[:id])

    respond_to do |format|
      if @graphic_arts_person.update_attributes(params[:graphic_arts_person])
        flash[:notice] = 'GraphicArtsPerson was successfully updated.'
        format.html { redirect_to(@graphic_arts_person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @graphic_arts_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /graphic_arts_people/1
  # DELETE /graphic_arts_people/1.xml
  def destroy
    @graphic_arts_person = GraphicArtsPerson.find(params[:id])
    @graphic_arts_person.destroy

    respond_to do |format|
      format.html { redirect_to(graphic_arts_people_url) }
      format.xml  { head :ok }
    end
  end
end
