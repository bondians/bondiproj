namespace :theme do
    task :list => :environment do
        desc "List of all Installed Themes"
        items = Setting.themes
        items.each_with_index do |itm, i|
            puts "#{i} - #{itm}"
        end
    end

    task :new => :list do
        desc "Generate new theme."
        items = Setting.themes
        puts "Please select the Theme to copy (0-#{items.length - 1})-> "
        old_theme = STDIN.gets.to_i
        while old_theme >= items.length
           puts "Please select the Theme to copy (0-#{items.length - 1})\nEnter a number only ->"
           old_theme = STDIN.gets.to_i
        end
        old_theme = items[old_theme.to_i]
        puts old_theme
        puts "Please enter a name for your new theme:, do not use quotes (Spaces are OK) ->"
        new_theme = STDIN.gets
        puts "\n#{old_theme} < #{new_theme}\n"
        new_theme.chomp!

        #Sanity Check
        raise "Theme name is in use" if items.include? new_theme

        old_theme_folder = File.expand_path(__FILE__ + "/../../../public/themes/" + old_theme)
        new_theme_folder = File.expand_path(__FILE__ + "/../../../public/themes/" + new_theme)
        new_theme_folder.gsub!(" ","\\ ")
        old_theme_folder.gsub!(" ","\\ ")

        system "mkdir #{new_theme_folder}"
        system "cp -r #{old_theme_folder}/* #{new_theme_folder}"

        old_theme.gsub!(" ","%20")
        new_theme.gsub!(" ","%20")

        system "perl -pi -e 's/#{old_theme}/#{new_theme}/' #{new_theme_folder + "/stylesheets/*"}"

    end

end