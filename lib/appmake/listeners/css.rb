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
				system("bundle exec sass css/app.scss public/app.css")
			end
		end
	end
end