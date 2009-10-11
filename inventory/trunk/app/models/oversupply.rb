class Oversupply < ActiveRecord::Base 
    has_many :surplus_items 
    attr_accessible :name, :building , :user_date, :contact  #, :surplus_items, :description, :make_model, :inventory_id_tag_number, :quantity, :condition_code
    # accepts_nested_attributes_for :surplus_items
  
  def surplus_items=(surplus_items)
     surplus_items.each do |attributes| 
         puts "inside surplus_items="
         puts attributes.to_yaml
         
       # surplus_items.build(attributes) 
     end
  end
  
    def self.create_params_from_pdf_params(params)
      @oversupply = Oversupply.new

      # create a hash that should be used to build the new model
      pdf_params = Hash.new
      # create that subhash that holds the Oversupply model's specific data
      os = Hash.new 
      os[:name] = params['FROM']
      os[:building] = params['BUILDING']
      os[:contact] = params['CONTACT']
      os[:user_date] = params['USERDATE'] #.to_date
      # move the Oversupply hash into the pdf_params hash - this part works upon creation
      pdf_params[:oversupply] = os


      # create an array to hold the line items off of the pdf form
      line_items = Array.new(27)# {Hash.new} - I was instantiating empty hashes in each element of
      # the array, but this proved problematic.  I couldn't .compact the array (or maybe I could, but I 
      # forgot to use .compact!  Either way, creating the hashes as needed is working, if long-winded.
      # Now I only make a hashwhen I find a matching number


      # I made a hash to translate the letters in the pdf form fields' names to the surplus_items 
      # field names.    
      real_names = { 'D' => :description , 'M' => :make_model , 'I' => :inventory_id_tag_number , 'Q' => :quantity , 'C' => :condition_code }

      # Yes, probably pedantic
      line_number = 0
      line_field = ""
      record_value = ""


      params.each do |key, value| 
        if !(value.empty?)
          if key =~ /([DMIC])(\d{1,2})/  # Look for those fields that contain text values, and remember 
                                                              # both the letter and the digit(s)
            line_number = $2.to_i
            line_field = real_names[$1]  # This uses my hash to match to a surplus_items field name
            record_value = value              # The value of the hash line-item
            if line_items[line_number]                                               # This is the only way I could figure out
              line_items[line_number][line_field] = record_value   # to only instantiate a hash if it was 
            else
              line_items[line_number] = Hash.new                          # empty, and stuff more key-value pairs
              line_items[line_number][line_field] = record_value  # into it if it was not
            end
           elsif key  =~ /(Q)(\d{1,2})/     # Same as above, except for integer values
             line_number = $2.to_i
             line_field = real_names[$1]
             record_value = value.to_i
             if line_items[line_number]    # Had to be pedantic here, too. Needed to keep these
               line_items[line_number][line_field] = record_value
             else                                           # assignments inside the inner loop. Maybe not, but it works.
               line_items[line_number] = Hash.new  
               line_items[line_number][line_field] = record_value
             end
          end
          # probably also pedantic. If I read up on the scope of $1 and #2 (the matched substrings)
          # I can probably do this better.
          line_number = nil
          line_field = ""
          record_value = ""
        end
       end 
     line_items.compact!  # Remove unused lines, since the pdf has 27 lines, most not used

     # I _think_ I'm putting this as an array of hashes inside the "params" hash
     # This is how it's depicted in the example on 
     # http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#M002132
     # but I may have given up on that technique unless someone can explain it (well, really, make it work for me)
     pdf_params[:oversupply][:surplus_items] = line_items

     params = pdf_params # Not sure if that word "params" is special, so I assign my pdf_params to it just in case
     puts "****** Model - Begin ******"
     puts params.to_yaml
     puts "******* Model - End *******"
     # I have nothing here to .build the related records
     # That's what I need help with, or help with the "new" way of nested attributes

     # @oversupply = Oversupply.create(params[:oversupply])
     #return @oversupply
     return params
   end
  end