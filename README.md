# Appmake

Single page apps made easy!

## Installation

Create app directory.

	mkdir myapp
	cd myapp

Create `Gemfile` with following content

	source :rubygems

	gem "appmake"

Run `bundle install`

## Usage

Run `bundle exec appmake init` to bootstrap app directory structure. Next issue `bundle exec appmake watch` to start automatic compillation of source files.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

**appmake** is being developed by Sebastian Sito and Sławomir Kołodziej