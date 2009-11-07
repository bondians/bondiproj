#!/usr/bin/env ruby -wKU
require 'optparse'
require 'ostruct'
require 'pp'
require 'pathname'
require 'yaml'

def unixify (filename)
  # change mac files to unix line endings, save under new name
 cmd = "tr '\r' '\n' < #{filename} > tr.#{filename} "
 system cmd
end

def act2array(accountline)
  actarray = [ accountline[0], { "dept" => accountline[1], "subdept" => accountline[2], "subacct" =>  accountline[3], "acct2" => accountline[4], "tiny" => accountline[5] } ]
  # return acthash
end 

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
  

# inputfile = ARGV[0]
p = Pathname.new(ARGV[0])
p = p.parent if p.file?

accts = Hash.new
depts = Hash.new
ords = Array.new

# depts << ["0", "blank"] # seems like priming the pumps with the accts will prime this one too
# accts << ["000000000000000", "0", "blank", "related"]

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
departments = File.new("departments.yml", "w")
orders = File.new("orders.yml", "w")
fail = File.new("failures.txt", "w")

accountID = 1
departmentID = 1

unixify("accounts.tab")

# establish accounts hash in memory
File.open("tr.accounts.tab", "r")  do |file|
  while line = file.gets
    lineitem = line.chomp.split(/\t/) # use the regexp /\t/, not the string '\t'
    linearray = act2array(lineitem)
    if accts.has_key?(linearray[0])
       fail.puts "* duplicate key *"
       fail.puts linearray[0]
       fail.puts "****************"
       fail.puts linearray[1].to_s
       fail.puts "---------------"
    else
       accts[linearray[0]]= linearray[1] 
    end
  # accounts.puts lineitem[0]
  end
end


accts.collect do |key, value|
 # if value[]
   puts "************"
   puts key
   puts "************"
   puts value["dept"]
   puts "----"
end


accounts.close
departments.close
orders.close


