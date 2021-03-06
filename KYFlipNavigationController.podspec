#
# Be sure to run `pod lib lint KYFlipNavigationController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KYFlipNavigationController"
  s.version          = "0.2.0"
  s.summary          = "A Custom NavigationController that use UIViewController to manager the UIViewCotroller which can use for push and pop"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
This Custome NavigationContoller can easy be used in UITabBarController and UINavigationController, You can push a UINavigationController or UITabBarController in a UINavigationController like EasyNet News app.
                       DESC

  s.homepage         = "https://github.com/kyleYang/KYFlipNavigationController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "kyleYang" => "yangzychina@gmail.com" }
  s.source           = { :git => "https://github.com/kyleYang/KYFlipNavigationController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  #s.resource_bundles = {
    #'KYFlipNavigationController' => ['Pod/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
