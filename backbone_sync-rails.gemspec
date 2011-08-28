$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "backbone_sync-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "backbone_sync-rails"
  s.version     = BackboneSyncRails::VERSION
  s.authors     = ["Jason Morrison"]
  s.email       = ["jason.p.morrison@gmail.com"]
  s.homepage    = "http://github.com/jasonm/backbone_sync-rails"
  s.summary     = "Broadcast changes from Rails models to client-side Backbone.js collections with WebSockets."
  s.description = "Broadcast changes from Rails models to client-side Backbone.js collections with WebSockets."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0.rc6"

  s.add_development_dependency "sqlite3"
end