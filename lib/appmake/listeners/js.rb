require "listen"

module Appmake
	module Listeners
		class Js
			def self.listen(bg = false)
				callback = Proc.new do |modified, added, removed|
					puts "=> rebuilding JS"
					system("node bin/compile_templates.js")
				end

				listener = Listen.to "js", :filter => /\.js$/
				listener.change(&callback)
				listener.start(bg)
			end
		end
	end
end