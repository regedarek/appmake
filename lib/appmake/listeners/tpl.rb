require "listen"

module Appmake
	module Listeners
		class Tpl
			include Thor::Shell

			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "tpl", :filter => /\.html$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				shell = Color.new
				
				shell.say_status :compile, "Templates", :green
				
				shell.say_status :cmd, "./node_modules/.bin/dot-module -d tpl/ -o js/templates.js", :blue
				system("./node_modules/.bin/dot-module -d tpl/ -o js/templates.js > /dev/null")
			end
		end
	end
end