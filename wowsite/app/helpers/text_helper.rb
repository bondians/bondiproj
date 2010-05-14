# By Henrik Nyh <http://henrik.nyh.se> 2008-01-30.
# Free to modify and redistribute with credit.

require "rubygems"
require "hpricot"

module TextHelper

  # Like the Rails _truncate_ helper but doesn't break HTML tags or entities.
  def truncate_html(text, max_length = 120, ellipsis = "&hellip;")
    return if text.nil?

    doc = Hpricot(text.to_s)
    ellipsis_length = Hpricot(ellipsis).inner_text.length
    content_length = doc.inner_text.length
    actual_length = max_length - ellipsis_length

    content_length > max_length ? doc.truncate(actual_length).inner_html + ellipsis : text.to_s
  end

end

module HpricotTruncator
  module NodeWithChildren
    def truncate(max_length)
      truncate_count(max_length)[0]
    end
    
    def truncate_count(max_length)
      inner_text_non_blanks = inner_text.scan(/\S/).length
      return [self, max_length - inner_text_non_blanks] if (inner_text_non_blanks <= max_length)
      
      truncated_node = self.dup
      truncated_node.children = []
      
      remaining = max_length
      each_child do |node|
        result = node.truncate_count(remaining)
        truncated_child = result[0]
        remaining = result[1]
        truncated_node.children << truncated_child
        break if remaining <= 0
      end
      [truncated_node, remaining]
    end
  end

  # Not a precise truncation to the requested length.  I consider it more
  # important that words not be split.
  module TextNode
    def truncate(max_length)
      truncate_count(max_length)[0]
    end
    
    def truncate_count(max_length)
      remaining = max_length
      words = content.scan(/\s+|\S+/)
      outWords = []
      
      while (remaining > 0 && words.length > 0) do
        word = words.shift
        outWords.push(word)
        remaining -= word.length if word.match(/^\S/)
      end
      
      outString = outWords.join
      
      if (words.length > 0 || remaining < 0) then
        remaining = 0 
        outString = outString + "&hellip;"
      end
      
      node = Hpricot::Text.new(outString)
      [node, remaining]
    end
  end

  module IgnoredTag
    def truncate(max_length)
      truncate_count(max_length)[0]
    end
    
    def truncate_count(max_length)
      [self, max_length]
    end
  end
end

Hpricot::Doc.send(:include,       HpricotTruncator::NodeWithChildren)
Hpricot::Elem.send(:include,      HpricotTruncator::NodeWithChildren)
Hpricot::Text.send(:include,      HpricotTruncator::TextNode)
Hpricot::BogusETag.send(:include, HpricotTruncator::IgnoredTag)
Hpricot::Comment.send(:include,   HpricotTruncator::IgnoredTag)
Hpricot::DocType.send(:include,   HpricotTruncator::IgnoredTag)
