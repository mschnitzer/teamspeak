Gem::Specification.new do |s|
  s.name        = 'teamspeak3'
  s.version     = '0.0.5'
  s.date        = ''
  s.summary     = 'A TeamSpeak 3 Query Library'
  s.description = 'An OOP library to query and manage TeamSpeak 3 servers in Ruby.'
  s.authors     = ['Manuel Schnitzer']
  s.email       = 'webmaster@mschnitzer.de'
  s.homepage    = 'https://github.com/mschnitzer/teamspeak3'
  s.license     = 'MIT'

  s.files       = Dir[
    'lib/**/*.rb',
    'spec/**/*.rb',
    '*.md',
    '.rspec'
  ]

  s.add_runtime_dependency 'net-telnet', '~> 0.1', '>= 0.1.1'

  s.add_development_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  s.add_development_dependency 'factory_bot', '~> 4.8', '>= 4.8.2'
end
