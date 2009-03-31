module SubmissionsHelper
  def fields_for_item(item, &block)
    prefix = item.new_record? ? 'new' : 'existing'
    fields_for("submission[#{prefix}_item_attributes][]", item, &block)
  end

  def add_item_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :items, :partial => 'item', :object => Item.new 
    end
  end
  
end