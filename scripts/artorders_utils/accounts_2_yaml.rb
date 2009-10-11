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