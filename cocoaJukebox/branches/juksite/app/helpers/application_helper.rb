# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def theme
      Setting.theme
  end
  
  def upper_right
    myTheme = theme;
    path = "#{RAILS_ROOT}/public/themes/#{myTheme}/images/upper_right.jpg"
    return "/themes/#{myTheme}/images/upper_right.jpg" if FileTest.file?(path)
    path = "#{RAILS_ROOT}/public/themes/#{myTheme}/images/upper_right.png"
    return "/themes/#{myTheme}/images/upper_right.png" if FileTest.file?(path)
    path = "#{RAILS_ROOT}/public/themes/#{myTheme}/images/upper_right.gif"
    return "/themes/#{myTheme}/images/upper_right.gif" if FileTest.file?(path)
    
    "/themes/standard/images/upper_right.png"
  end
  
  def jukebox_image
    myTheme = theme;
    path = "#{RAILS_ROOT}/public/themes/#{myTheme}/images/jukebox.jpg"
    return "/themes/#{myTheme}/images/jukebox.jpg" if FileTest.file?(path)
    path = "#{RAILS_ROOT}/public/themes/#{myTheme}/images/jukebox.png"
    return "/themes/#{myTheme}/images/jukebox.png" if FileTest.file?(path)
    path = "#{RAILS_ROOT}/public/themes/#{myTheme}/images/jukebox.gif"
    return "/themes/#{myTheme}/images/jukebox.gif" if FileTest.file?(path)
    
    "/themes/standard/images/jukebox.png"
  end
end
