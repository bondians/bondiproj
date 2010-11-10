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
        puts "Please select the Theme to copy -> "
        old_theme = STDIN.gets
        puts old_theme
    end
    
end