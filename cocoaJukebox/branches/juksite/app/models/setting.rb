class Setting < ActiveRecord::Base
  
  def self.hide_protected?
    return Setting.current.hideprotected if Setting.current
    return true
  end
  
  def self.hide_protected=(value)
    setting = Setting.current || Setting.new
    setting.hideprotected = value
    setting.save
  end

  def self.allow_playlists?
    return Setting.current.allowplaylist if Setting.current
    return false
  end
  
  def self.allow_playlists=(value)
    setting = Setting.current || Setting.new
    setting.allowplaylist = value
    setting.save
  end

  def self.theme=(theme)
    setting = Setting.current || Setting.new
    setting.theme = theme
    setting.save
  end
  
  def self.theme
    theme = Setting.current.theme
    theme ||= "standard"
  end
  
  
  def self.current
    return Setting.first
  end
  
  def self.themes
    stuff = `ls "#{RAILS_ROOT}/public/themes/"`
    list = stuff.to_a
    list.each {|b| b.chomp!}
  end
  
end
