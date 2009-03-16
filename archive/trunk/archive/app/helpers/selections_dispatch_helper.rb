module SelectionsDispatchHelper
  ## If you want to add a button, add the button to the _wrapper view with some sort of unique value
  ## Then go to the controller for this helper, and add it to dispatch
  
  ## Call with an already sorted array of songs to display
  
  
  ## For each element you add, you should decide whether its present by default, or only when needed.
  ## Then wrap it in an 'unless' or 'if' statement as appropriate to toggle.
  ## on by default
  # :checkbox  <= also disables all buttons (it should but dosn't, they need to be disabled on their own)
  # :title
  # :artist
  # :album
  # :genre
  # :size
  # :type
  # :get
  # :playlist_sel <= playlist pulldown list
  # :playlist_add <= add button for playlist
  
  ## off by defoult
  # :playlist_del <= delet buttor for playlist
  
    def draw_songs(songs, *nodraws)
      render :file => "#{RAILS_ROOT}/app/views/selections_dispatch/_wrapper.html.erb", :locals => {:songs => songs, :nodraws => nodraws}
    end
    
end
