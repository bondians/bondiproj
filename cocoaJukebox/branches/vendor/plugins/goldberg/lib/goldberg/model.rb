require 'active_record/connection_adapters/postgresql_adapter'

# Set the appropriate table prefix using AR's "set_table_name" 

# This module is included in all Goldberg's model classes.  On load it
# adds the prefix "goldberg." to all table names if the connection is
# to PostgreSQL; otherwise it adds the prefix "g_".

module Goldberg
  module Model

    def self.included(base)
      base.class_eval do
        
        def self.prefix
          if not @prefix
              @prefix = 'goldberg_'
          end
          @prefix
        end
        
        (table_name =~ /goldberg/) ||
          (set_table_name "#{self.prefix}#{self.table_name}")
      end
    end
end    
  end

