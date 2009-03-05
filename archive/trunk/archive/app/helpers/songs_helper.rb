module SongsHelper

## Helper
  # Used for the column that is the default sort
  def default_sortable_header(column, order, text = nil)
    column = column.to_s.downcase
    order = order.to_s.downcase
    opposite = order == "desc" ? "asc" : "desc"
    text ||= column.humanize
    query_string = ""
    if params[:search]
      query_string << "&amp;search="
      query_string << params[:sort]
    end
    if params[:sort]
      if params[:sort] == column
        text << direction_span(params[:direction] == "desc" ? "&#8595;" : "&#8593;")
      end
    else
      query_string << "sort=#{column}"
      query_string << "&amp;direction="
      query_string << (params[:direction] == order ? opposite : order)
      text << direction_span(opposite == "desc" ? "&#8595;" : "&#8593;")
    end
    link_to text, query_string.blank? ? request.path : "#{request.path}?#{query_string}"
  end
  
  # Used for other columns
  def sortable_header(column, order, text = nil)
    column = column.to_s
    order = order.to_s
    opposite = order == "desc" ? "asc" : "desc"
    text ||= column.humanize
    query_string = "sort=#{column}"
    query_string << "&amp;direction="
    query_string << (params[:sort] == column && params[:direction] == order ? opposite : order)
    if params[:search]
      query_string << "&amp;search="
      query_string << params[:sort]
    end
    if params[:sort] == column
      text << direction_span(params[:direction] == "desc" ? "&#8595;" : "&#8593;")
    end
    link_to text, query_string.blank? ? request.path : "#{request.path}?#{query_string}"
  end
  
  private
  def direction_span(content)
    content_tag :span, content, :class => :direction
  end


end
