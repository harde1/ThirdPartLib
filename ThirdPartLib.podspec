

Pod::Spec.new do |s|

  s.name         = "ThirdPartLib"
  s.version      = "0.0.1"
  s.summary      = "一句命令完成微信登录的环境"
  s.description  = "
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //微信登录
    [self wxRegisterAppID:WXCHAT_APPID];
    return YES;}
"
  s.homepage     = "http://github.com/harde1/ThirdPartLib"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "cong" => "harde1@163.com" }

  s.platform     = :ios, "5.0"

  s.source       = { :git => "http://github.com/harde1/ThirdPartLib.git", :commit => '4f30bb8f6fa5fc9a2c03a49ff965f0a53dae0505 }

  s.source_files  = "ThirdPartLib/*.{h,m}"
  s.requires_arc = true

  s.dependency "ReactiveCocoa", "2.5"
  s.dependency "WXSDKCoreKit", "~> 1.6.2"

end
