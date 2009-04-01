pdf.text "Order ##{@submission.id}", :size => 30, :style => :bold

pdf.move_down(30)

items = @submission.items.map do |item|
  [
    item.description,
    item.make,
    item.number,
    item.qty
  ]
end

pdf.table items, :border_style => :grid,
  :row_colors       => ["FFFFFF","DDDDDD"],
  :headers          => ["Product", "Make", "Reference ID", "Quantity"],
  :column_widths    => { 0=>200, 1=>100, 2=>100, 3=>100},
  :align            => { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
