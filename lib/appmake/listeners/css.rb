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
				shell = Color.new

				shell.say_status :compile, "CSS", :green
				
				Dir.glob "css/*" do |f|
					name = f.split("/").last

					if name[0] == name[0].upcase
						new_name = name.gsub "scss", "css"
						shell.say_status :cmd, "bundle exec sass css/#{name} public/css/#{new_name}", :blue
						system "bundle exec sass css/#{name} public/css/#{new_name} > /dev/null"
					end
				end
			end
		end
	end
end