require "listen"

module Appmake
	module Listeners
		class Coffee
			include Thor::Shell

			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "js", :filter => /\.coffee$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				Basic.new.say_status :compile, "CoffeScript"
				
				Dir.glob "js/*.coffee" do |f|
					name = f.split("/").last
					new_name = name.gsub "coffee", "js"

					system "./node_modules/.bin/coffee -c js/#{name} js/#{new_name}"

					if name[0] == name[0].upcase
						system "./node_modules/.bin/webmake js/#{name} public/js/#{name}"
					end
				end
			end
		end
	end
end