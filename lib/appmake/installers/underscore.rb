require "thor"

module Appmake
	module Installers
		class Underscore
			include Thor::Shell

			def self.install
				shell = Color.new

				shell.say_status :install, "Underscore", :green
				shell.say_status :cmd, "curl http://underscorejs.org/underscore-min.js -o public/underscore.min.js", :blue
				system("curl -silent http://underscorejs.org/underscore-min.js -o public/underscore.min.js")
			end
		end
	end
end