# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'weatherCity' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for weatherCity
  pod 'Moya',                              :git => 'https://github.com/Moya/Moya',                                :tag => '11.0.2'
  pod 'ObjectMapper',                      :git => 'https://github.com/tristanhimmelman/ObjectMapper',            :tag => '3.4.0'
  pod 'Alamofire',                         '~> 4.7'

  target 'weatherCityTests' do
    inherit! :search_paths
  end

end

target 'weatherCityUITests' do
    inherit! :search_paths
    pod 'Moya',                              :git => 'https://github.com/Moya/Moya',                                :tag => '11.0.2'
    pod 'ObjectMapper',                      :git => 'https://github.com/tristanhimmelman/ObjectMapper',            :tag => '3.4.0'
    pod 'Alamofire',                         '~> 4.7'
end
