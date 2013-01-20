require "thor"
require "appmake/version"
require "appmake/listeners/css"
require "appmake/listeners/coffee"
require "appmake/listeners/js"
require "appmake/listeners/tpl"
require "appmake/installers/jquery"

module Appmake
  class Appmake < Thor
		include Thor::Actions

		def self.source_root
			File.dirname(File.dirname(__FILE__))
		end

		desc "init", "initialize new application"
		{
			:coffee => false,
			:jquery => true,
			:underscore => false,
			:backbone => false,
			:bootstrap => false
		}.each do |op, default|
			method_option op, :type => :boolean, :default => default, :aliases => op.to_s
		end

		def init
			shell = Color.new

			template "templates/package.json.tt", "package.json"
			template "templates/README.md.tt", "README.md"

			empty_directory "css"
			template "templates/css/App.scss.tt", "css/App.scss"
			template "templates/css/body.scss.tt", "css/body.scss"

			empty_directory "js"
			template "templates/js/App.js.tt", "js/App.js"

			if options.coffee
				empty_directory "coffee"
			end

			empty_directory "tpl"
			template "templates/tpl/welcome.html.tt", "tpl/welcome.html"

			empty_directory "public"
			empty_directory "public/css"
			empty_directory "public/js"
			empty_directory "public/img"
			template "templates/public/index.html.tt", "public/index.html"

			shell.say_status :cmd, "npm install", :blue
			system "npm install &> /dev/null"

			Listeners::Css.compile
			Listeners::Coffee.compile
			Listeners::Tpl.compile
			Listeners::Js.compile
		end

		desc "watch", "watch for files to compile"
		def watch
			Listeners::Css.listen(false)
			Listeners::Coffee.listen(false)
			Listeners::Tpl.listen(false)
			Listeners::Js.listen(true)
		end

		desc "install", "install various libs"
		def install(name)
			shell = Color.new

			if name == "jquery"
				Installers::Jquery.install
			elsif name == "underscore"
				shell.say_status :cmd, "curl http://underscorejs.org/underscore-min.js -o public/underscore.min.js", :blue
				system("curl -silent http://underscorejs.org/underscore-min.js -o public/underscore.min.js")
			elsif name == "backbone"
				shell.say_status :cmd, "curl http://backbonejs.org/backbonejs-min.js -o public/backbone.min.js", :blue
				system("curl -silent http://backbonejs.org/backbone-min.js -o public/backbone.min.js")
			elsif name == "bootstrap"
				shell.say_status :cmd, "curl http://twitter.github.com/bootstrap/assets/bootstrap.zip -o public/bootstrap.zip", :blue
				shell.say_status :cmd, "cd public", :blue
				shell.say_status :cmd, "unzip bootstrap.zip &> /dev/null", :blue
				shell.say_status :cmd, "mv bootstrap/js/bootstrap.min.js js/", :blue
				shell.say_status :cmd, "mv bootstrap/css/bootstrap.min.css css/", :blue
				shell.say_status :cmd, "mv bootstrap/css/bootstrap-responsive.min.css css/", :blue
				shell.say_status :cmd, "mv bootstrap/img/* img/", :blue
				shell.say_status :cmd, "rm -rf bootstrap && rm bootstrap.zip", :blue
				system("curl -silent http://twitter.github.com/bootstrap/assets/bootstrap.zip -o public/bootstrap.zip && cd public && unzip bootstrap.zip &> /dev/null && mv bootstrap/js/bootstrap.min.js js/ && mv bootstrap/css/bootstrap.min.css css/ && mv bootstrap/css/bootstrap-responsive.min.css css/ && mv bootstrap/img/* img/ && rm -rf bootstrap && rm bootstrap.zip")
			else
				abort "error: unsupported install: #{name}"
			end
		end
	end
end
