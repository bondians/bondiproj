class Finder < ActiveRecord::Base
  
  def self.lastrun
    runs = Finder.all :order => :started
    (runs.select{|run| run.success}).last
  end
  
  def self.fresh
    run = Finder.new
    run.started = Time.now
    run.added = 0
    run.removed = 0
    return run
  end
end
