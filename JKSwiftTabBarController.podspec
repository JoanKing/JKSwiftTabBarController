
Pod::Spec.new do |s|
  s.name             = 'JKSwiftTabBarController'
  s.version          = '0.0.3'
  s.summary          = 'TabBarController的基本配置'
  s.description      = '这是TabBarController的一个详细的使用文档，支持下载后的更新，也支持文档的更新'
  s.homepage         = 'https://github.com/JoanKing/JKSwiftTabBarController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '王冲' => 'jkironman@163.com' }
  s.source           = { :git => 'https://github.com/JoanKing/JKSwiftTabBarController.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'JKSwiftTabBarController/Classes/**/*'
  s.swift_version = '5.0'
  s.dependency 'SnapKit'
  
end
