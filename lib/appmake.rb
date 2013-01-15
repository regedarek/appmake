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
			empty_directory "bin"
			template"templates/bin/compile_templates.js.tt", "bin/compile_templates.js"

			empty_directory "css"
			template"templates/css/app.scss.tt", "css/app.scss"
			template"templates/css/body.scss.tt", "css/body.scss"

			empty_directory "js"
			template"templates/js/lib/doT.js.tt", "js/lib/doT.js"
			template"templates/js/app.js.tt", "js/app.js"

			empty_directory "tpl"
			template "templates/tpl/welcome.html.tt", "tpl/welcome.html"

			empty_directory "public"
			template "templates/public/index.html.tt", "public/index.html"

			Listeners::Css.compile
			Listeners::Js.compile
			Listeners::Tpl.compile
		end

		desc "watch", "watch for files to compile"
		def watch
			Listeners::Css.listen(false)
			Listeners::Js.listen(false)
			Listeners::Tpl.listen(true)
		end
	end
end
