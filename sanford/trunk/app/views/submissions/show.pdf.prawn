pdf.text "Request ##{@submission.id}", :size => 30, :style => :bold

pdf.move_down(30)

items = @submission.items.map do |item|
  [
    item.description,
    item.make,
    item.number,
    item.qty,
    item.condition.code
  ]
end

pdf.table items, :border_style => :grid,
  :row_colors       => ["FFFFFF","DDDDDD"],
  :headers          => ["Product", "Make", "Reference ID", "Quantity", "CC"],
  :column_widths    => { 0=>200, 1=>100, 2=>100, 3=>100, 4=>40},
  :align            => { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
  
pdf.move_down(30)

pdf.text %{Condition Codes (CC) #{Condition.all.map{|c| "#{c.code} = #{c.name}   "}}}
