require "thor"
require "appmake/version"
require "appmake/listeners/css"
require "appmake/listeners/coffee"
require "appmake/listeners/js"
require "appmake/listeners/tpl"
require "appmake/installers/backbone"
require "appmake/installers/bootstrap"
require "appmake/installers/jquery"
require "appmake/installers/underscore"

module Appmake
  class Appmake < Thor
		include Thor::Actions

		def self.source_root
			File.dirname(File.dirname(__FILE__))
		end

		desc "init", "initialize new application"
		{
			:coffee => false,
			:jquery => false,
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

			empty_directory "tpl"
			template "templates/tpl/welcome.html.tt", "tpl/welcome.html"

			empty_directory "public"
			empty_directory "public/css"
			empty_directory "public/js"
			empty_directory "public/img"
			template "templates/public/index.html.tt", "public/index.html"

			shell.say_status :cmd, "npm install", :blue
			system "npm install &> /dev/null"

			if options.coffee
				empty_directory "coffee"
				Listeners::Coffee.compile
			end

			if options.jquery
				Installers::Jquery.install
			end

			if options.underscore
				Installers::Underscore.install
			end

			if options.backbone
				Installers::Backbone.install
			end

			if options.bootstrap
				Installers::Bootstrap.install
			end

			Listeners::Css.compile
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
				empty_directory "public"
				empty_directory "public/js"
				Installers::Jquery.install
			elsif name == "underscore"
				empty_directory "public"
				empty_directory "public/js"
				Installers::Underscore.install
			elsif name == "backbone"
				empty_directory "public"
				empty_directory "public/js"
				Installers::Backbone.install
			elsif name == "bootstrap"
				empty_directory "public"
				empty_directory "public/css"
				empty_directory "public/img"
				empty_directory "public/js"
				Installers::Bootstrap.install
			else
				abort "error: unsupported install: #{name}"
			end
		end
	end
end
