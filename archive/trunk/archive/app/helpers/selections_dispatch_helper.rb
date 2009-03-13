module SelectionsDispatchHelper
  ## If you want to add a button, go to the controller for this helper, and add it to dispatch
  ## Then add the button to the _wrapper view with some sort of unique value
  ## Call with an already sorted array of songs
  ## Variable number of :symbols for any column you want _NOT_ displayed
  ## available for nodraw:
  # :checkbox  <= also disables all buttons
  # :title
  # :artist
  # :album
  # :genre
  # :size
  # :type
  # :get
  
    def draw_songs(songs, *nodraws)
      render :template => "selections_dispatch/wrapper", :locals => {:songs => songs, :nodraws => nodraws}
    end
    
end
