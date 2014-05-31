# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fun_with_patterns"
  gem.homepage = "http://github.com/darthschmoo/fun_with_patterns"
  gem.license = "MIT"
  gem.summary = "A collection of useful patterns"
  gem.description = "A collection of useful patterns"
  gem.email = "keeputahweird@gmail.com"
  gem.authors = ["Bryce Anderson"]
  # dependencies defined in Gemfile
  
  gem.files = Dir.glob( File.join( ".", "lib", "**", "*.rb" ) ) + 
              Dir.glob( File.join( ".", "test", "**", "*" ) ) +
              %w( Gemfile Rakefile LICENSE.txt README.rdoc VERSION CHANGELOG.markdown )  
  
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fun_with_patterns #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
