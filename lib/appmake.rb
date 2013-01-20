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
			system "npm install"

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
			template "templates/public/index.html.tt", "public/index.html"

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
	end
end
