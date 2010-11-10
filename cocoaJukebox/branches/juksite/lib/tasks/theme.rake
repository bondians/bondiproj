namespace :theme do
    task :list => :environment do
        desc "List of all Installed Themes"
        items = Setting.themes
        items.each_with_index do |itm, i|
            puts "#{i} - #{itm}"
        end
    end
    
    task :new do
        desc "Generate new theme."
        a = gets
        puts a
    end
    
end