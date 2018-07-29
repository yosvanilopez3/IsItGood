platform :ios, '10.0'
use_frameworks!

target 'IsItGood' do

  # Firebase
  pod 'SwiftyJSON', '~> 4.0'

  pod 'IoniconsSwift', :git => 'http://github.com/tidwall/IoniconsSwift.git', :branch => 'master'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
