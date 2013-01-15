require "thor"
require "appmake/version"
require "appmake/listeners/css"
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
			system("npm install")

			empty_directory "css"
			template"templates/css/app.scss.tt", "css/app.scss"
			template"templates/css/body.scss.tt", "css/body.scss"

			empty_directory "js"
			template"templates/js/app.js.tt", "js/app.js"

			empty_directory "tpl"
			template "templates/tpl/welcome.html.tt", "tpl/welcome.html"

			empty_directory "public"
			template "templates/public/index.html.tt", "public/index.html"

			Listeners::Css.compile
			Listeners::Tpl.compile
			Listeners::Js.compile
		end

		desc "watch", "watch for files to compile"
		def watch
			Listeners::Css.listen(false)
			Listeners::Tpl.listen(false)
			Listeners::Js.listen(true)
		end
	end
end
