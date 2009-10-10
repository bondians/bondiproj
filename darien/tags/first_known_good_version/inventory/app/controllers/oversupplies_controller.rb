class OversuppliesController < ApplicationController
  def index
    @oversupplies = Oversupply.all
  end
  
  def show
    @oversupply = Oversupply.find(params[:id])
  end
  
  def new
     @oversupply = Oversupply.new 
        
  end
  
  def create
      # check if this action comes from a pdf by checking the value of a field on the pdf
      if params['PDF_SUBMISSION'] == 'v1.1b'
        # Oversupply model has a method to sort out the flat params
        # and return a hash
        my_params = Oversupply.create_params_from_pdf_params(params)
        
        # How many line items are there? 
        quan_items = my_params[:oversupply][:surplus_items].length
        puts "****** Controller - Begin ******"
        puts "There are this many items: " + quan_items.to_s
        puts my_params.to_yaml
        puts "******* Controller - End *******" 
        
        @oversupply = Oversupply.new(my_params[:oversupply])
        # puts @oversupply.class   # after returning from model method, is HashWithIndifferentAccess
        puts "in the controller " + @oversupply[:oversupply].to_yaml     # [:surplus_items_attributes]
        if @oversupply.save
            # Create related records - does not work
            my_params[:oversupply][:surplus_items].each do |surplus_params| 
                # Old way wasn't working { @oversupply.surplus_items.build }
               surplus_params.merge!({:oversupply_id => @oversupply.id })
               new_params = {:surplus_item => surplus_params }
               puts "These are the surplus_params: " + surplus_params.to_yaml
               puts "These are the params: " + new_params.to_yaml
               item = SurplusItems.new(new_params[:surplus_item])
               item.save
            end
            render :action => "show", :template => "oversupplies/receipt" 
        else
          render :text => "Your PDF submission didn't work. Print out the pdf and send it to Tom."
        end
      else
        @oversupply = Oversupply.new(params[:oversupply])
          if @oversupply.save
            flash[:notice] = "Successfully created oversupply."
            redirect_to @oversupply
          else
            render :action => 'new'
          end
       end
  end
  
  def edit
    @oversupply = Oversupply.find(params[:id])
  end
  
  def update
    @oversupply = Oversupply.find(params[:id])
    if @oversupply.update_attributes(params[:oversupply])
      flash[:notice] = "Successfully updated oversupply."
      redirect_to @oversupply
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @oversupply = Oversupply.find(params[:id])
    @oversupply.destroy
    flash[:notice] = "Successfully destroyed oversupply."
    redirect_to oversupplies_url
  end
end
