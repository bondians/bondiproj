#!/usr/bin/env ruby -wKU
require 'optparse'
require 'ostruct'
require 'pp'
require 'pathname'

# File input: output file of a FileMaker Accounts file
# as created by D.G. Henderson for the Graphic Arts Dept of the AUHSD
#
# File output: one accounts.yml file
#             one departments.yml file
# 
# The accounts.yml file should have departments_id fields for each account number
# that refers to a department by name.
#
# I couldn't get the new way of using named relations to work.
# This script will use the old way of having the _id field
  

inputfile = ARGV[0]
outputpath = ARGV[1]

p = Pathname.new(ARGV[1])

begin
  # see if the outpath directory exists
  Dir.chdir(p)
  puts "able to change to that directory"
  
  rescue SystemCallError 
     # Try to create the directory
    begin
      Dir.mkdir(p)
      
      puts "able to create the directory"      
      rescue SystemCallError
        # Was unable to create directory
        puts "was not able to change to that directory"      
      raise
    end
end

accounts = File.new("accounts.yml", "w")
cmd = "touch ./findme.txt"
system cmd

accounts.print("Hello\r")

accounts.close


File.open(inputfile, "r")  do |file|
  # puts file.path
  while line = file.gets
    #puts line
  end
end


