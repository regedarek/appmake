require "listen"

module Appmake
	module Listeners
		class Js
			def initialize
				listener = Listen.to "js", :filter => /\.js$/
				listener.change(callback)
				listener
			end

			def callback
				Proc.new do |modified, added, removed|
					puts "=> rebuilding JS"
					system("node bin/compile_templates.js")
				end
			end
		end
	end
end