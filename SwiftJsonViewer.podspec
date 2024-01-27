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

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'SwiftJsonViewer is a SwiftUI view that is used to display JsonData in a tree structure format. User have to pass that valid JsonData (Array/Dictionary) object as a parameter in the JsonTreeViewModel.'
                       DESC

  s.homepage         = 'https://github.com/sheleshr/SwiftJsonViewer'
  s.screenshots     = 'https://shorturl.at/lmNT1', 'https://shorturl.at/dwzJP'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sheleshr' => 'sheleshrawat@gmail.com' }
  s.source           = { :git => 'https://github.com/sheleshr/SwiftJsonViewer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://shorturl.at/eiqwy'

  s.ios.deployment_target = '16.0'

  s.source_files = 'Source/**/*.swift'
  s.swift_version = '5.0'
  s.platforms = { :ios => "16.0" }
  
  s.resource_bundles = {
     'SwiftJsonViewer' => ['Source/**/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.frameworks = 'SwiftUI', 'Foundation', 'Combine'
end
