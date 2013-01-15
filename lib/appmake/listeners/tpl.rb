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
				Basic.new.say_status :compile, "CSS"
				system("dot-module -d tpl/ -o js/templates.js")
			end
		end
	end
end