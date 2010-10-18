class Setting < ActiveRecord::Base
  
  def self.hide_protected?
    return Setting.first.hideprotected if Setting.first
    return true
  end
  
  def self.hide_protected=(value)
    setting = Setting.first || Setting.new
    setting.hideprotected = value
    setting.save
  end
  
end
