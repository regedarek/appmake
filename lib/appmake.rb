require "thor"
require "appmake/version"

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
		end

		desc "watch", "watch for files to compile"
		def watch
			js_listener = Listeners::Js.new
			js_listener.start
		end
	end
end
