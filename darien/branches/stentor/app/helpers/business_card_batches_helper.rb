module BusinessCardBatchesHelper

  def calculate_batch_quantity
    # Figures out the optimum number of cards to print for each layout, based on the number of cards ordered
    # For example, if the first 20 card_orders (by quantity) are all 500 cards, that would be a perfectly filled-out
    # 20-up layout of cards, and we'd print 500 copies of it.
    # If the first 2 orders want 2000, and the next 2 want 1000, and the next 8 want 500, 
    # that would be a perfectly filled up 500-count layout as well - 
    # 8 spots @ ( 2000/4 = 500 ) + 4 spots @ (1000/2 = 500) + 8 spots @ (500/1 = 500) = 20 spots

    # What this should do:
    # 
     # Read in some card_orders, sorted from most quantity first
     # some other stuff...
     
    # for now, set by hand
    return (BusinessCardOrder.fewest_cards(1)).collect{ |t| t.quantity }.first
    #  return 500
  end



end
