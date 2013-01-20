require "thor"

module Appmake
	module Installers
		class Backbone
			include Thor::Shell

			def self.install
				shell = Color.new

				shell.say_status :install "Backbone", :green
				shell.say_status :cmd, "curl http://backbonejs.org/backbonejs-min.js -o public/backbone.min.js", :blue
				system("curl -silent http://backbonejs.org/backbone-min.js -o public/backbone.min.js")
			end
		end
	end
end