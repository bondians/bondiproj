# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

    Mime::Type.register "audio/x-mpegurl", :m3u
    Mime::Type.register "image/jpeg", :jpg
    Mime::Type.register "image/png", :png
    Mime::Type.register "application/x-tar", :tar
    Mime::Type.register "text/plain", :txt
        #Mime::Type.register "application/json", :json

   
  begin 
  Songtype.all.each do |type|
     Mime::Type.register type.mime_type, type.identifier
  end
  rescue
  puts "No Songtype table, probably a new install?"
  end
  