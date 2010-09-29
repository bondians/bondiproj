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

require File.expand_path(__FILE__ + "/../config/environment")


tables = ActiveRecord::Base.connection.tables

tables.each do |table|
  puts table
end
