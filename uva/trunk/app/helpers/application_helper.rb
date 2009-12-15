# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def snippet(thought, wordcount) 
  # wordcount = 10 
  thought.split[0..(wordcount-1)].join(" ") + (thought.split.size > wordcount ? "..." : "") 
  end
  
end
