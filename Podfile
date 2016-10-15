platform :ios, '9.0'

target 'JsonPatchSwift' do
  use_frameworks!

	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'

  target 'JsonPatchSwiftTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end