require "thor"
require "appmake/version"
require "appmake/listeners/css"
require "appmake/listeners/coffee"
require "appmake/listeners/js"
require "appmake/listeners/tpl"

module Appmake
  class Appmake < Thor
		include Thor::Actions

		def self.source_root
			File.dirname(File.dirname(__FILE__))
		end

		desc "init", "initialize new application"
		def init
			template "templates/package.json.tt", "package.json"
			template "templates/README.md.tt", "README.md"

			empty_directory "css"
			template "templates/css/App.scss.tt", "css/App.scss"
			template "templates/css/body.scss.tt", "css/body.scss"

			empty_directory "js"
			template "templates/js/App.js.tt", "js/App.js"

			empty_directory "coffee"

			empty_directory "tpl"
			template "templates/tpl/welcome.html.tt", "tpl/welcome.html"

			empty_directory "public"
			empty_directory "public/css"
			empty_directory "public/js"
			empty_directory "public/img"
			template "templates/public/index.html.tt", "public/index.html"

			system "npm install"

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
			if name == "jquery"
				system("curl http://code.jquery.com/jquery-1.9.0.min.js -o public/jquery-1.9.0.min.js")
			elsif name == "underscore"
				system("curl http://underscorejs.org/underscore-min.js -o public/underscore.min.js")
			elsif name == "backbone"
				system("curl http://backbonejs.org/backbonejs-min.js -o public/backbone.min.js")
			elsif name == "bootstrap"
				system("curl http://twitter.github.com/bootstrap/assets/bootstrap.zip -o public/bootstrap.zip && cd public && unzip bootstrap.zip && mv bootstrap/js/bootstrap.min.js js/ && mv bootstrap/css/bootstrap.min.css css/ && mv bootstrap/css/bootstrap-responsive.min.css css/ && mv bootstrap/img/* img/ && rm -rf bootstrap && rm bootstrap.zip")
			else
				abort "error: unsupported install: #{name}"
			end
		end
	end
end
