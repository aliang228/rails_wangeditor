# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_wangeditor/version"

Gem::Specification.new do |s|
  s.name        = "rails_wangeditor"
  s.version     = RailsWangeditor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "rubycat"
  s.email       = "chenxueping1819@gmail.com"
  s.homepage    = "https://github.com/a598799539/rails_wangeditor"
  s.summary     = "wangEditor for Ruby on Rails"
  s.description = "rails_wangeditor will helps your rails app integrate with wangEditor, including images uploading."
  s.license = 'MIT'

  s.rubyforge_project = "rails_wangeditor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("carrierwave")
  s.add_dependency("mini_magick")
end
