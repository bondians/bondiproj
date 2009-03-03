class Tagit
  
  ##Tries to parse a tag, and returns some sort of usefully defined object.
  ##Initially only parses id3v2 tags, hopefully expandable to work on every tag type
  sub self.read_tag(tag)
    case tag[:id]
        when "APIC"     # Picture
        when "COMM"     # Comment
        when "IPLS"     # InvolvedPeople
        when "MCDI"     # MusicCDIdentifier
        when "PCNT"     # PlayCounter
        when "PRIV"     # Private --> ID3 Private Tags
        when "TALB"     # Album
        when "TBPM"     # BeatsPerMinute
        when "TCMP"     # Compilation   0 = No 1 = Yes
        when "TCOM"     # Composer
        when "TCON"     # Genre (uses same lookup table as ID3v1 Genre)
        when "TCOP"     # Copyright 
        when "TDAT"     # Date
        when "TDLY"     # PlaylistDelay
        when "TENC"     # EncodedBy
        when "TEXT"     # Lyricist
        when "TFLT"     # FileType
        when "TIME"     # Time
        when "TIT1"     # Grouping
        when "TIT2"     # Title
        when "TIT3"     # Subtitle
        when "TKEY"     # InitialKey
        when "TLAN"     # Language
        when "TLEN"     # Length
        when "TMED"     # Media
        when "TOAL"     # OriginalAlbum
        when "TOFN"     # OriginalFilename
        when "TOLY"     # OriginalLyricist
        when "TOPE"     # OriginalArtist
        when "TORY"     # OriginalReleaseYear
        when "TOWN"     # FileOwner
        when "TPE1"     # Artist
        when "TPE2"     # Band
        when "TPE3"     # Conductor
        when "TPE4"     # InterpretedBy
        when "TPOS"     # PartOfSet
        when "TPUB"     # Publisher
        when "TRCK"     # Track
        when "TRDA"     # RecordingDates
        when "TRSN"     # InternetRadioStationName 
        when "TRSO"     # InternetRadioStationOwner
        when "TSIZ"     # Size
        when "TSRC"     # ISRC
        when "TSSE"     # EncoderSettings
        when "TXXX"     # UserDefinedText
        when "TYER"     # Year
        when "USER"     # TermsOfUse
        when "USLT"     # Lyrics
        when "WCOM"     # CommercialURL
        when "WCOP"     # CopyrightURL
        when "WOAF"     # FileRUL
        when "WOAR"     # ArtistURL
        when "WOAS"     # SourceURL
        when "WORS"     # InternetRadioStationURL
        when "WPAY"     # PaymentURL
        when "WPUB"     # PublisherURL
        when "WXXX"     # UserDefinedURL
        else
            nil
    end
end
  
end
