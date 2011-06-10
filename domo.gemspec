# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "domo/version"

Gem::Specification.new do |s|
  s.name = "domo"
  s.version = Domo::Version.to_s
  s.platform = Gem::Platform::RUBY
  s.authors = ["cynipe"]
  s.email = ["cynipe@cynipe.net"]
  s.summary = %q{Domo is the super-duper simple client for Jenkins}

  s.files = Dir.glob("**/*")
  s.executables = ["domo"]
  s.require_paths = ["lib"]

  s.add_dependency("mechanize")
  s.add_dependency("nokogiri")
  s.add_dependency("highline")
  s.add_dependency("thor")
end
