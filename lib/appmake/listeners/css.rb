require "listen"

module Appmake
	module Listeners
		class Css
			def self.listen(bg = true)
				callback = Proc.new do |modified, added, removed|
					puts "=> rebuilding CSS"
					system("bundle exec sass css/app.scss css/app.css")
				end

				listener = Listen.to "css", :filter => /\.scss$/
				listener.change(&callback)
				listener.start(bg)
			end
		end
	end
end