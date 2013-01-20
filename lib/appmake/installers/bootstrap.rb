require "thor"

module Appmake
	module Installers
		class Bootstrap
			include Thor::Shell

			def self.install
				shell = Color.new

				shell.say_status :install, "Bootstrap", :green
				shell.say_status :cmd, "curl http://twitter.github.com/bootstrap/assets/bootstrap.zip -o public/bootstrap.zip", :blue
				shell.say_status :cmd, "cd public", :blue
				shell.say_status :cmd, "unzip bootstrap.zip &> /dev/null", :blue
				shell.say_status :cmd, "mv bootstrap/js/bootstrap.min.js js/", :blue
				shell.say_status :cmd, "mv bootstrap/css/bootstrap.min.css css/", :blue
				shell.say_status :cmd, "mv bootstrap/css/bootstrap-responsive.min.css css/", :blue
				shell.say_status :cmd, "mv bootstrap/img/* img/", :blue
				shell.say_status :cmd, "rm -rf bootstrap && rm bootstrap.zip", :blue
				system("curl -silent http://twitter.github.com/bootstrap/assets/bootstrap.zip -o public/bootstrap.zip && cd public && unzip bootstrap.zip &> /dev/null && mv bootstrap/js/bootstrap.min.js js/ && mv bootstrap/css/bootstrap.min.css css/ && mv bootstrap/css/bootstrap-responsive.min.css css/ && mv bootstrap/img/* img/ && rm -rf bootstrap && rm bootstrap.zip")
			end
		end
	end
end