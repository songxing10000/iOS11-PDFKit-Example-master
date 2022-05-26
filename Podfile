 
 platform :ios, '12.0'
inhibit_all_warnings!
source 'https://cdn.cocoapods.org/'

install! 'cocoapods',
:generate_multiple_pod_projects => true,
:incremental_installation => true,
:warn_for_unused_master_specs_repo => false

target 'PDF-Demo' do

  
  use_frameworks!
pod 'SnapKit'
end
post_install do |installer|
  installer.pod_target_subprojects.flat_map { |p| p.targets }.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12'
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
