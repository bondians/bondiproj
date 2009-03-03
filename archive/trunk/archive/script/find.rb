require 'find'
  Find.find(".") do |path|
      if FileTest.file?(path)
        puts "#{path} is a file"
      else
        puts "#{path} is not a file"
    end
  end
