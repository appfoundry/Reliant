Pod::Spec.new do |s|
  s.name         = 'Reliant'
  s.version      = '1.1.0'
  s.summary      = 'Reliant is a light-weight Dependency Injection (DI) framework for Objective-C, both for OS X and iOS.'
  s.homepage     = 'https://github.com/appfoundry/Reliant'
  s.license      = 'MIT'
  s.authors      = { 'Mike Seghers' => 'mike.seghers@appfoundry.be' }
  s.source       = { :git => 'https://github.com/appfoundry/Reliant.git', :tag => '1.1.0' }

  s.private_header_files = 'Reliant/OCSClassRuntimeInfo.h', 'Reliant/OCSPropertyRuntimeInfo.h', 'Reliant/DRYRuntimMagic.h'

  s.ios.deployment_target = '6.0'
  s.ios.source_files = 'Reliant/*.{h,m}', 'Reliant/iOS/*.{h,m}'

  s.osx.deployment_target = '10.8'
  s.osx.source_files = 'Reliant/*.{h,m}'

  s.exclude_files = 'Classes/Exclude'
  s.frameworks = 'Foundation'
  s.ios.frameworks = 'UIKit'
  s.requires_arc = true
end
