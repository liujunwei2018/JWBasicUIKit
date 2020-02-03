#
# Be sure to run `pod lib lint JWBasicUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JWBasicUIKit'
  s.version          = '0.1.1'
  s.summary          = 'A short description of JWBasicUIKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/liujunwei2018/JWBasicUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liujunwei2018' => 'liujunwei0422@icloud.com' }
  s.source           = { :git => 'https://github.com/liujunwei2018/JWBasicUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'UIView' do |uIView|
    uIView.source_files = 'JWBasicUIKit/Classes/UIView/**/*.{h,m}'
    uIView.public_header_files = 'JWBasicUIKit/Classes/UIView/**/*.h'
  end
  s.subspec 'UIButton' do |uIButton|
    uIButton.source_files = 'JWBasicUIKit/Classes/UIButton/**/*.{h,m}'
    uIButton.public_header_files = 'JWBasicUIKit/Classes/UIButton/**/*.h'
  end
  s.subspec 'UILabel' do |uILabel|
    uILabel.source_files = 'JWBasicUIKit/Classes/UILabel/**/*.{h,m}'
    uILabel.public_header_files = 'JWBasicUIKit/Classes/UILabel/**/*.h'
  end
  s.subspec 'UIColor' do |uIColor|
    uIColor.source_files = 'JWBasicUIKit/Classes/UIColor/**/*.{h,m}'
    uIColor.public_header_files = 'JWBasicUIKit/Classes/UIColor/**/*.h'
  end
  s.subspec 'UIImage' do |uIImage|
    uIImage.source_files = 'JWBasicUIKit/Classes/UIImage/**/*.{h,m}'
    uIImage.public_header_files = 'JWBasicUIKit/Classes/UIImage/**/*.h'
  end
  s.subspec 'UIFont' do |uIFont|
    uIFont.source_files = 'JWBasicUIKit/Classes/UIFont/**/*.{h,m}'
    uIFont.public_header_files = 'JWBasicUIKit/Classes/UIFont/**/*.h'
  end
  s.subspec 'UIScrollView' do |uIScrollView|
    uIScrollView.source_files = 'JWBasicUIKit/Classes/UIScrollView/**/*.{h,m}'
    uIScrollView.public_header_files = 'JWBasicUIKit/Classes/UIScrollView/**/*.h'
    uIScrollView.dependency 'JWBasicUIKit/UIView'

  end
  s.subspec 'UITextfield' do |uITextfield|
    uITextfield.source_files = 'JWBasicUIKit/Classes/UITextfield/**/*.{h,m}'
    uITextfield.public_header_files = 'JWBasicUIKit/Classes/UITextfield/**/*.h'
  end
  s.subspec 'UITextView' do |uITextView|
    uITextView.source_files = 'JWBasicUIKit/Classes/UITextView/**/*.{h,m}'
    uITextView.public_header_files = 'JWBasicUIKit/Classes/UITextView/**/*.h'
  end
  s.subspec 'AlertView' do |alertView|
    alertView.source_files = 'JWBasicUIKit/Classes/AlertView/**/*.{h,m}'
    alertView.public_header_files = 'JWBasicUIKit/Classes/AlertView/**/*.h'
    alertView.dependency 'JWBasicUIKit/UIImage'
    alertView.dependency 'JWBasicUIKit/UIColor'
    alertView.dependency 'JWBasicUIKit/UIFont'
  end

  s.public_header_files = 'JWBasicUIKit/Classes/JWBasicUIKit.h'
  s.source_files = 'JWBasicUIKit/Classes/JWBasicUIKit.h'
  
  s.dependency 'SDWebImage'
  s.dependency 'Masonry'
end
