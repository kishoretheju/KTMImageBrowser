#
# Be sure to run `pod lib lint KTMImageBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KTMImageBrowser'
  s.version          = '0.1.0'
  s.summary          = 'To show multiple large images as pages along with thumbnails. Each large image can be zoomed in/out.'
  s.description      = <<-DESC
To show multiple large images as pages along with thumbnails. Each large image can be zoomed in/out. Can be used as a image browser.
                       DESC

  s.homepage         = 'https://github.com/kishoretheju/KTMImageBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kishore Thejasvi' => 'kishore.thejasvi@gmail.com' }
  s.source           = { :git => 'https://github.com/kishoretheju/KTMImageBrowser.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kishore_munna'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KTMImageBrowser/Classes/**/*'
  
  s.resource_bundles = {
   'KTMImageBrowser' => ['KTMImageBrowser/Assets/*.{storyboard,xib}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.0'
end
