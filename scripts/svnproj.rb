module SVN
	class MakeProj
		def initialize(proj,dir)
			@proj = proj
			@dir = dir
		end

		def makeit()
			puts "Well, I'ma gonna make this project named #{@proj}"
		end
	end
end


svn = SVN::MakeProj.new("TestProj","Ruby/Rocks")
svn.makeit


