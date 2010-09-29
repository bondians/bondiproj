#!/usr/bin/env ruby

require 'find'
require 'id3lib'
require 'mp4info'
require 'ruby-debug'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'
require 'optparse'

RAILS_ENV = "production"

require File.expand_path(__FILE__ + "/../../config/environment")

system "rm db/jukebox.sqlite3"
system "rake goldberg:migrate RAILS_ENV='jukebox'"
system "rake db:migrate RAILS_ENV='jukebox'"

file = File.open("/tmp/commands.txt", "wb")

file.printf(".separator '\t'")

#pg_dump -a mp3 -t genres > genres.db.out
#./cleaner.pl genres.db.out genres.db

SUDO = "sudo -u cayuse"
COMMAND = "pg_dump -a"
DB = (__FILE__ + "/../db/jukebox.sqlite3")
CLEANER = (__FILE__ + "/../cleaner.pl")


tables = ActiveRecord::Base.connection.tables
cmd = sprintf("%s %s %s -t %s > /tmp/%s.tmp.input", SUDO, COMMAND, DB, table, table )
system cmd
secondcmd = sprintf("%s /tmp/%s.tmp.input /tmp/%s.input", CLEANER, table, table)

file.printf(".import %s.input %s\n", table, table)
tables.each do |table|
  file.printf(".import")
end
