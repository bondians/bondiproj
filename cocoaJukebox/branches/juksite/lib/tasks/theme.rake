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
        puts items[old_theme.to_i]
        puts "Please enter a name for your new theme, do not use quotes (Spaces are OK) ->"
        new_theme = STDIN.gets
        puts new_theme
        new_theme.chomp!
    end

end