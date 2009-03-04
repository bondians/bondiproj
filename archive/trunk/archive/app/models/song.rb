class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :genre
  belongs_to :songtype
  validates_presence_of :songtype
  
  define_index do
    indexes title, :sortable => true
    indexes album.name, :as => :album, :sortable => true
    indexes artist.name, :as => :artist, :sortable => true
    indexes genre.name, :as => :genre, :sortable => true
  end
  
  private
  def order_with_default(column, direction)
    if params[:sort]
      "#{params[:sort]} #{params[:direction]}, #{column} #{direction}"
    else
      "#{column} #{direction}"
    end
  end
  
end
