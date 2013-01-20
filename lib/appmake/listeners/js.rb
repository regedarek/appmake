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
				Basic.new.say_status :compile, "JS"
				
				Dir.glob "js/*.js" do |f|
					name = f.split("/").last

					if name[0] == name[0].upcase
						system "webmake js/#{name} public/js/#{name}"
					end
				end
			end
		end
	end
end