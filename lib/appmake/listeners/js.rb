require "listen"

module Appmake
	module Listeners
		class Js
			include Thor::Shell

			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "js", :filter => /\.js$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				shell = Color.new

				shell.say_status :compile, "JavaScript", :green
				
				Dir.glob "js/*.js" do |f|
					name = f.split("/").last

					if name[0] == name[0].upcase
						shell.say_status :cmd, "./node_modules/.bin/webmake js/#{name} public/js/#{name}", :blue
						system "./node_modules/.bin/webmake js/#{name} public/js/#{name} > /dev/null"
					end
				end
			end
		end
	end
end