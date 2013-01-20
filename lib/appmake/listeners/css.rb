require "listen"
require "thor"

module Appmake
	module Listeners
		class Css
			include Thor::Shell

			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "css", :filter => /\.scss$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				Basic.new.say_status :compile, "CSS"
				
				Dir.glob "css/*" do |f|
					name = f.split("/").last

					if name[0] == name[0].upcase
						new_name = name.gsub "scss", "css"
						system "bundle exec sass css/#{name} public/css/#{new_name}"
					end
				end
			end
		end
	end
end