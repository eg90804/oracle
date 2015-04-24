source "http://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 3.7.0'
  gem "puppet-lint"
  gem "rspec-puppet" , :git => 'https://github.com/doc75/rspec-puppet.git', :branch => 'update-to-rspec3'
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
  gem 'librarian-puppet'
end

group :development do
  gem 'byebug'
  gem 'debugger'
  gem 'pry'
  gem 'pry-debugger'
  gem "travis"
  gem "travis-lint"
  gem 'beaker', :github => 'puppetlabs/beaker', :branch => 'master', :ref => '74e7ffb5b9024d5c87833b0e4226517eb0860711'
  gem "beaker-rspec"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end
