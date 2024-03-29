Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sunspot_search'
  s.version     = '1.1.2'
  s.summary     = 'Add Solr search to Spree via the Sunspot gem'
  s.description = 'Sunspot and Spree have a wonderful baby'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = ['John Brien Dilts', 'Michael Bianco']
  s.email             = ['jdilts@railsdog.com', 'info@cliffsidedev.com']
  s.homepage          = 'http://www.railsdog.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 1.3.0')
  s.add_dependency('sunspot_rails')
  s.add_dependency('progress_bar')

  s.add_development_dependency('sunspot_solr')
end
