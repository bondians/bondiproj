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

		end

		def initialize()
		end

		def makeit()
			p = Pathname.new(@dir)
			if p.directory?
				puts "Well, I'ma gonna make this project named #{@proj} in the dir #{@dir}"
			else
				puts "Sorry, the directory #{@dir} does not exist.."
		end
	end
end


svn = SVN::MakeProj.new()
svn.parse(ARGV)
svn.makeit


