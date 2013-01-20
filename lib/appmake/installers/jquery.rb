require "thor"

module Appmake
	module Installers
		class Jquery
			include Thor::Actions

			def self.install
				shell = Color.new

				shell.say_status :cmd, "curl http://code.jquery.com/jquery-1.9.0.min.js -o public/jquery-1.9.0.min.js", :blue
				system("curl -silent http://code.jquery.com/jquery-1.9.0.min.js -o public/jquery-1.9.0.min.js")
			end
		end
	end
end