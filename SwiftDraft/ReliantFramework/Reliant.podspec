Pod::Spec.new do |s|
  s.name         = 'Reliant'
  s.version      = '3.0.0'
  s.summary      = 'Reliant is a light-weight Dependency Injection (DI) framework for Swift, both for OS X and iOS.'
  s.homepage     = 'https://github.com/appfoundry/Reliant'
  s.license      = 'MIT'
  s.authors      = { 'Mike Seghers' => 'mike.seghers@appfoundry.be' }
  s.source       = { :git => 'https://github.com/appfoundry/Reliant.git', :tag => s.version.to_s }

  s.source_files = 'ReliantFramework/*.{swift}'

  s.ios.deployment_target = '8.0'
  s.ios.exclude_files = 'ReliantFramework/OSX/*'

  s.osx.deployment_target = '10.8'
  s.osx.exclude_files = 'ReliantFramework/iOS/*'

  s.frameworks = 'Foundation'
  s.requires_arc = true
end
