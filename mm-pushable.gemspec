$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mm-pushable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mm-pushable"
  s.version     = Pushable::VERSION
  s.authors     = ["Bill Transue"]
  s.email       = ["transue@gmail.com"]
  s.homepage    = "http://github.com/billy-ran-away/mm-pushable"
  s.summary     = "Effortlessly push MongoMapper Model changes to Backbone.js clients."
  s.description = "Broadcast changes from MongoMapper models to client-side Backbone.js collections and models with WebSockets."

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.0.0"
  s.add_dependency 'mongo_mapper', '>= 0.9.0'

  s.add_development_dependency 'bson'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'debugger'
end
