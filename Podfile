# Uncomment this line to define a global platform for your project
 platform :ios, '8.0'
# Uncomment this line if you're using Swift
# use_frameworks!

pod 'Alamofire', '3.4.1'
pod 'AFNetworking', '3.1.0’
pod 'SDWebImage'
pod 'MJRefresh', '3.1.10’
pod 'SVProgressHUD', '1.1.3’
pod 'TPKeyboardAvoiding','1.3’
pod 'MBProgressHUD','0.9.2'
pod 'libWeChatSDK', '1.7.1'
pod 'ZLPhotoBrowser','1.0.7'
pod 'BaiduMapKit','3.0.0'

use_frameworks!
target '51Bang_ios_2016' do

end

target '51Bang_ios_2016Tests' do

end

target '51Bang_ios_2016UITests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end