$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scubaru/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scubaru"
  s.version     = Scubaru::VERSION
  s.authors     = ["JoshAshby"]
  s.email       = ["joshuaashby@joshashby.com"]
  s.homepage    = "TODO"
  s.summary     = "Basic utils to help with rails deving"
  s.description = "TODO: Description of Scubaru."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "awesome_print"
end
