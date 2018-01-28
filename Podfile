
platform :ios, '11.2'
inhibit_all_warnings!
use_frameworks!

def common_pods
    pod 'SwiftWormhole', '~> 1.2'
end

def host_pods
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'SwiftyUserDefaults'
    pod 'HexColors'
    pod 'NotificationBannerSwift', '~> 1.5'
end

target 'Memento' do
    common_pods
    host_pods
end
 
target 'Widget' do
    common_pods
end
