require "listen"

module Appmake
	module Listeners
		class Tpl
			def self.listen(bg = true)
				callback = Proc.new do |modified, added, removed|
					puts "=> rebuilding TPL"
					system("node js/compile_templates.js")
				end

				listener = Listen.to "tpl", :filter => /\.html$/
				listener.change(&callback)
				listener.start(bg)
			end
		end
	end
end