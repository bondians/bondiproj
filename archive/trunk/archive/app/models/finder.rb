class Finder < ActiveRecord::Base
  
  def self lastrun
    runs = Finder.all :order => :started
    (runs.select{|run| run.success}).last
  end
end
