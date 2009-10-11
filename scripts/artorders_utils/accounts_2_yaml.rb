#!/usr/bin/env ruby -wKU

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

# see if the outpath directory exists
begin
  Dir.chdir(outputpath)
  puts "able to change to that directory"
  
  rescue SystemCallError 
     #Dir.mkdir(outputpath)

    # raise 
    begin
      Dir.mkdir(outputpath)
      rescue SystemCallError
        puts "was not able to change to that directory"      
      raise
    end
end



File.open(inputfile, "r")  do |file|
  puts file.path
  while line = file.gets
    #puts line
  end
end
