require "listen"

module Appmake
	module Listeners
		class Coffee
			include Thor::Shell

			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "coffee", :filter => /\.coffee$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				shell = Color.new

				shell.say_status :compile, "CoffeScript", :green
				
				Dir.glob "coffee/*.coffee" do |f|
					name = f.split("/").last
					new_name = name.gsub "coffee", "js"

					shell.say_status :cmd, "./node_modules/.bin/coffee -c coffee/#{name} && mv coffee/#{new_name} js/#{new_name}", :blue
					system "./node_modules/.bin/coffee -c coffee/#{name} > /dev/null && mv coffee/#{new_name} js/#{new_name} > /dev/null"

					if name[0] == name[0].upcase
						shell.say_status :cmd, "./node_modules/.bin/webmake js/#{new_name} public/js/#{new_name}", :blue
						system "./node_modules/.bin/webmake js/#{new_name} public/js/#{new_name} > /dev/null"
					end
				end
			end
		end
	end
end