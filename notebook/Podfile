# Uncomment the next line to define a global platform for your project

#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'notebook' do
# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'FolioReaderKit', path: '../'
end

# Pods for notebook

shared_pods

pod 'RxSwift', '4.3.1'
pod 'RxCocoa', '4.3.1'
pod 'Alamofire' #, '4.7.0'# is elegant HTTP Networking
pod 'Log' # is an extensible logging framework
pod 'Reusable' # is a Swift mixin for reusing views easily and in a type-safe way
pod 'iCarousel'
pod 'AlamofireObjectMapper', '5.1.0'
pod 'SDWebImage'
pod 'IQKeyboardManager'
pod 'Firebase/Analytics'
pod 'Firebase/Messaging'
pod 'Gifu'
pod 'Firebase/DynamicLinks'
pod 'KeychainSwift'

end
