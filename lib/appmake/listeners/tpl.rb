require "listen"

module Appmake
	module Listeners
		class Tpl
			def self.listen(block = true)
				callback = Proc.new do |modified, added, removed|
					self.compile()
				end

				listener = Listen.to "tpl", :filter => /\.html$/
				listener.change(&callback)
				listener.start(block)
			end

			def self.compile
				puts "=> rebuilding TPL"
				system("node js/compile_templates.js")
			end
		end
	end
end