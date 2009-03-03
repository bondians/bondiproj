#=> [{:textenc=>0, :text=>"O Holy Night", :id=>:TIT2}, {:textenc=>0, :text=>"Leontyne Price", :id=>:TPE1},
#{:textenc=>0, :text=>"Leontyne Price : Christmas Songs", :id=>:TALB}, {:textenc=>0, :text=>"Unclassifiable", :id=>:TCON},
#{:textenc=>0, :text=>"iTunes v1.0", :id=>:TENC}, {:textenc=>0, :text=>"11/13", :id=>:TRCK},
#{:description=>"", :textenc=>0, :text=>"164348", :id=>:TXXX}]

def tagit
  Tagger.instance
end

class Tagger
  
  ##Tries to parse a tag, and returns some sort of usefully defined object.
  ##Initially only parses id3v2 tags, hopefully expandable to work on every tag type
  sub read_tag(tag)
  end
  
end
