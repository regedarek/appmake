require "thor"
require "listen"
require "appmake/version"

module Appmake
	class Appmake < Thor
		include Thor::Actions

		def self.source_root
			File.dirname(File.dirname(__FILE__))
		end

		desc "init", "initialize new app"
		method_option :coffee, :type => :boolean, :default => false
		method_option :jquery, :type => :boolean, :default => false
		method_option :underscore, :type => :boolean, :default => false
		method_option :backbone, :type => :boolean, :default => false
		method_option :bootstrap, :type => :boolean, :default => false
		def init
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
			template "templates/public/index.html.tt", "public/index.html"

			empty_directory "public/css"
			empty_directory "public/js"
			empty_directory "public/img"

			if options.coffee?
				empty_directory "coffee"
			end

			if options.jquery?
				install "jquery"
			end

			if options.underscore?
				install "underscore"
			end

			if options.backbone?
				install "backbone"
			end

			if options.bootstrap?
				install "bootstrap"
			end

			run "npm install"

			compile "css"
			compile "tpl"
			compile "coffee"
			compile "js"
		end

		desc "compile", "compile files"
		method_option :name, :type => :string
		def compile(name)
			if name == "css"
				Dir.glob "css/*.scss" do |f|
					name = f.split("/").last
					if name[0] == name[0].upcase
						new_name = name.gsub "scss", "css"
						run "bundle exec sass css/#{name} public/css/#{new_name}"
					end
				end
			elsif name == "js"
				Dir.glob "js/*.js" do |f|
					name = f.split("/").last
					if name[0] == name[0].upcase
						run "./node_modules/.bin/webmake js/#{name} public/js/#{name}"
					end
				end
			elsif name == "tpl"
				run "./node_modules/.bin/dot-module -d tpl/ -o js/templates.js"
			elsif name == "coffee"
				Dir.glob(File.join("**", "coffee", "**", "*.coffee")) do |f|
					run "./node_modules/.bin/coffee -c #{f}"
					coffee_dir = f.gsub(f.split("/").last, "")
					js_dir = coffee_dir.gsub "coffee", "js"
					empty_directory js_dir
					js_file = f.gsub "coffee", "js"
					run "mv #{f.gsub('.coffee', '.js')} #{js_file}"

					Dir.glob "js/*.js" do |js|
						name = js.split("/").last
						if name[0] == name[0].upcase
							run "./node_modules/.bin/webmake #{js} public/js/#{name}"
						end
					end
				end
			end
		end

		desc "watch", "watch for files to compile"
		def watch
			css = Listen.to "css", :filter => /\.scss$/
			css.change do
				compile "css"
			end
			css.start(false)

			if Dir.exists? "coffee"
				coffee = Listen.to "coffee", :filter => /\.coffee$/
				coffee.change do
					compile "coffee"
				end
				coffee.start(false)
			end

			tpl = Listen.to "tpl", :filter => /\.html$/
			tpl.change do
				compile "tpl"
			end
			tpl.start(false)

			js = Listen.to "js", :filter => /\.js$/
			js.change do
				compile "js"
			end
			js.start(true)
		end

		desc "install", "install lib"
		method_option :name, :type => :string
		def install(name)
			if name == "jquery"
				empty_directory "public"
				empty_directory "public/js"
				run "curl http://code.jquery.com/jquery-1.9.0.min.js -o public/js/jquery.min.js"
			elsif name == "underscore"
				empty_directory "public"
				empty_directory "public/js"
				run "curl http://underscorejs.org/underscore-min.js -o public/js/underscore.min.js"
			elsif name == "backbone"
				empty_directory "public"
				empty_directory "public/js"
				run "curl http://backbonejs.org/backbone-min.js -o public/js/backbone.min.js"
			elsif name == "bootstrap"
				empty_directory "public"
				empty_directory "public/css"
				empty_directory "public/img"
				empty_directory "public/js"
				run "curl http://twitter.github.com/bootstrap/assets/bootstrap.zip -o public/bootstrap.zip"
				run "unzip public/bootstrap.zip -d public"
				run "mv public/bootstrap/js/bootstrap.min.js public/js/"
				run "mv public/bootstrap/css/bootstrap.min.css public/css/"
				run "mv public/bootstrap/css/bootstrap-responsive.min.css public/css/"
				run "mv public/bootstrap/img/* public/img/"
				run "rm -rf public/bootstrap"
				run "rm public/bootstrap.zip"
			else
				abort "error: cannot install #{name}"
			end
		end
	end
end