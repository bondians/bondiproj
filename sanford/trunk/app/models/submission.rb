class Submission < ActiveRecord::Base
  belongs_to :user, :class_name=>"Goldberg::User", :foreign_key=>:user_id
  belongs_to :status
  belongs_to :summary
  
  has_many :items, :dependent => :destroy
  
  validates_presence_of :name
  validates_associated :items
  
  after_update :save_items

  if Goldberg.user
  named_scope :user, :conditions => ["user_id = ?", Goldberg.user.id]
  end
  
  def new_item_attributes=(item_attributes)
    item_attributes.each do |attributes|
      items.build(attributes)
    end
  end
  
  def existing_item_attributes=(item_attributes)
    items.reject(&:new_record?).each do |item|
      attributes = item_attributes[item.id.to_s]
      if attributes
        item.attributes = attributes
      else
        items.delete(item)
      end
    end
  end
  
  def save_items
    items.each do |item|
      item.save(false)
    end
  end

end
