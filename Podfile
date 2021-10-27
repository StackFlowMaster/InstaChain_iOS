platform :ios, '12.0'
use_frameworks!

target 'InstaChain' do
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Firestore'
    pod 'Firebase/Analytics'
    pod 'Firebase/Storage'
    pod 'CodableFirebase'
    pod 'RxSwift', '~> 4.5'
    pod 'RxCocoa', '~> 4.5'
    pod 'RxDataSources', '~> 3.0'
    pod 'RxBiBinding'
    pod 'SwiftGen', '~> 6.1.0'
    pod 'ESTabBarController-swift'
    pod 'M13Checkbox'
    pod 'MaterialComponents/Snackbar'
    pod 'SVProgressHUD', :git => 'https://github.com/mmdock/SVProgressHUD.git', :branch => 'patch-1'
    pod 'TZImagePickerController'
    pod 'SDWebImage', '~> 5.0'
    pod 'GrowingTextView', '0.6.1'
end

target 'InstaChainTests' do
    pod 'Firebase/Core'
end

target 'InstaChainUITests' do
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end
