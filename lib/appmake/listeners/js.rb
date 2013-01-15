require "listen"

module Appmake
	module Listeners
		class Js
			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "js", :filter => /\.js$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				puts "=> rebuilding JS"
				system("webmake js/app.js public/app.js")
			end
		end
	end
end