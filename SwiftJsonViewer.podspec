#
# Be sure to run `pod lib lint SwiftJsonViewer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'SwiftJsonViewer'
  s.version          = '0.1.1'
  s.summary          = 'SwiftJsonViewer is a SwiftUI view that is used to display JsonData in a tree structure format'

  s.description      = 'SwiftJsonViewer is a SwiftUI view that is used to display JsonData in a tree structure format. User have to pass that valid JsonData (Array or Dictionary) object as a parameter in the JsonTreeViewModel.'

  s.homepage         = 'https://github.com/sheleshr/SwiftJsonViewer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sheleshr' => 'sheleshrawat@gmail.com' }
  s.source           = { :git => 'http://github.com/sheleshr/SwiftJsonViewer.git', :tag => 'v0.1.1' }
  s.ios.deployment_target = '16.0'
  s.source_files     = 'Source/**/*.swift'
  s.swift_version    = '5.0'
  s.platforms        = { :ios => '16.0' }
  s.resource_bundles = { 'SwiftJsonViewer' => 'Source/**/*.png' }
  s.frameworks = 'SwiftUI', 'Foundation', 'Combine'

end
