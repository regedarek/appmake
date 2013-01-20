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
				Basic.new.say_status :compile, "CoffeScript"
				
				Dir.glob "coffee/*" do |f|
					name = f.split("/").last
					new_name = name.gsub "coffee", "js"

					system "./node_modules/.bin/coffee -c coffee/#{name} coffee/#{new_name}"

					if name[0] == name[0].upcase
						system "./node_modules/.bin/webmake coffee/#{name} public/js/#{name}"
					end
				end
			end
		end
	end
end