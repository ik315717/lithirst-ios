use_frameworks!
platform :ios, '9.0'

def shared_pods
  pod 'Alamofire', '~> 4.4'
  pod 'ObjectMapper'
  pod 'OHHTTPStubs/Swift'
  pod 'SwiftyJSON'
end

target 'LI Thirst' do
  shared_pods
end

target 'Testing App' do
  shared_pods
end

target 'Unit Tests' do
 shared_pods
 pod 'Quick'
pod 'Nimble'
end

target 'UI Tests' do
  shared_pods
end

