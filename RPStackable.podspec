#
# Be sure to run `pod lib lint RPStackable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RPStackable'
  s.module_name      = "Stackable"
  s.version          = '0.1.7'
  s.summary          = 'Stackable is a delightful and declarative set of utilities for UIStackView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Stackable is a delightful and declarative set of utilities for UIStackView. It is designed to make your layout code easier to write, read, and communicate with your designer. Stackable aims to bridge the gap between the way designers articulate layout and the way developers express that layout in code.
                       DESC

  s.homepage         = 'https://github.com/Rightpoint/Stackable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jclark@rightpoint.com' => 'jclark@rightpoint.com' }
  s.source           = { :git => 'https://github.com/Rightpoint/Stackable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.0']
  
  s.source_files = 'Stackable/**/*'

  # s.public_header_files = 'Pod/**/*.h'
  s.frameworks = 'UIKit'

end
