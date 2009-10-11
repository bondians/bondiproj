#!/usr/bin/env ruby -wKU
require 'optparse'
require 'ostruct'
require 'pp'
require 'pathname'


module SVN
	class MakeProj

		def parse(args)

			options = OpenStruct.new
			options.proj = ""
			options.dir = ""
			options.url = "https://deepbondi.devguard.com/svn/bondiproj/"

			opts = OptionParser.new do |opts|
				opts.banner = "Usage: svnproj.rb [options]"

				opts.separator ""
				opts.separator "Specific options:"

				opts.on("-p", "--project PROJECT" ,
					"Require the PROJECT before executing the script") do |proj|
					options.proj << proj
				end

				opts.on("-d", "--directory DIRECTORY" ,
					"Require the DIRECTORY before executing the script") do |dir|
					options.dir << dir
				end
			end

			opts.parse!(args)
			options
			#puts options.proj
			#puts options.dir
			@proj = options.proj
			@dir = options.dir
			@url = options.url
			puts options.url

		end

		def initialize()
		end

		def makeit()
			p = Pathname.new(@dir)
			if p.directory?
				puts "Good news... directory #{@dir} exists!"
				puts "Well, I'ma gonna make this project named #{@proj}."
				system "svn info"

				cmd = "svn mkdir #{@url}/#{@proj}/ -m \"This is a test\""
				puts "Running:#{cmd}"
				system cmd

				dirs = ['trunk', 'branches', 'tags']

				# Now, make the trunk, branches and tags dirs
				dirs.each do |dir|
					cmd = "svn mkdir #{@url}/#{@proj}/#{dir} -m \"Build dir #{@proj}/#{dir}\""
					puts "Running:#{cmd}"
					system cmd
				end

				# Then, import dir into trunk
				cmd = "svn import #{@dir} #{@url}/#{@proj}/trunk  -m \"Import into trunk.\""
				puts "Running:#{cmd}"
				system cmd
			else
				puts "Sorry, the directory #{@dir} does not exist.."
			end
		end
	end
end


svn = SVN::MakeProj.new()
svn.parse(ARGV)
svn.makeit


