#
# Be sure to run `pod lib lint ALNetWorkingSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALNetWorkingSwift'
  s.version          = '0.1.0'
  s.summary          = '利用Alamofire进行再度封装网络库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                          利用Alamofire进行再度封装，以适合日常需求
                         DESC

  s.homepage         = 'https://github.com/Anyeler/ALNetWorkingSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anyeler' => '414116969@qq.com' }
  s.source           = { :git => 'https://github.com/Anyeler/ALNetWorkingSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.module_name      = 'ALNetWorking'
  s.platform         = :ios, '8.0'
  # s.ios.deployment_target = '8.0'

  s.source_files = 'ALNetWorkingSwift/Classes/*.swift'
  s.requires_arc = true
  # s.resource_bundles = {
  #   'ALNetWorkingSwift' => ['ALNetWorkingSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency "Alamofire", '4.7.2'
  s.dependency "HandyJSON", '4.1.1'

  s.subspec 'Core' do |ba|
    ba.source_files = 'ALNetWorkingSwift/Classes/Core/*.swift'
  end

end
