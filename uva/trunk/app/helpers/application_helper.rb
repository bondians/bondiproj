# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end                                                   

  def stylesheets(*files)
    content_for(:head) { stylesheet_link_tag(*files) }  
  end

  def snippet(thought, wordcount) 
    # wordcount = 10 
    thought.split[0..(wordcount-1)].join(" ") + (thought.split.size > wordcount ? "..." : "") 
  end

end
