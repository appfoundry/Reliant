Pod::Spec.new do |s|
  s.name         = 'Reliant'
  s.version      = '2.0.2'
  s.summary      = 'Reliant is a light-weight Dependency Injection (DI) framework for Objective-C, both for OS X and iOS.'
  s.homepage     = 'https://github.com/appfoundry/Reliant'
  s.license      = 'MIT'
  s.authors      = { 'Mike Seghers' => 'mike.seghers@appfoundry.be' }
  s.source       = { :git => 'https://github.com/appfoundry/Reliant.git', :tag => s.version.to_s }

  s.private_header_files = 'Reliant/Classes/Runtime/*.h,Reliant/Classes/ContextLocator/OCSBoundContextLocatorFactory.h'
  s.source_files = 'Reliant/Classes/**/*.{h,m}'

  s.ios.deployment_target = '6.0'
  s.ios.exclude_files = 'Reliant/Classes/ContextLocator/OSX/*'

  s.osx.deployment_target = '10.8'
  s.osx.exclude_files = 'Reliant/Classes/Categories/UIKit/*', 'Reliant/Classes/ContextLocator/iOS/*'

  s.frameworks = 'Foundation'
  s.ios.frameworks = 'UIKit'
  s.osx.frameworks = 'AppKit'
  s.requires_arc = true
end
