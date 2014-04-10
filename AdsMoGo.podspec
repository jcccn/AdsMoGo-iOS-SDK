Pod::Spec.new do |s|
  s.name     = 'AdsMoGo'
  s.version  = '1.4.5'
  s.summary  = 'AdsMoGo is the Largest Mobile Sell-Side Platform in China.'
  s.homepage = 'https://github.com/jcccn/AdsMoGo-iOS-SDK'
  s.author   = { 'Chuncheng Jiang' => 'jccuestc@gmail.com' }
  s.license  = { :type => 'Copyright', :text => <<-LICENSE
                   © 芒果移动广告优化平台
                 LICENSE
               }
  s.source   = { :git => 'https://github.com/jcccn/AdsMoGo-iOS-SDK.git', :tag => '1.4.5' }
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.default_subspec = 'Normal'

  ### Subspecs

  s.subspec 'Normal' do |ns|
    ns.requires_arc = true
    ns.dependency 'AdsMoGo/AdsMoGoSDK'
    ns.dependency 'AdsMoGo/Baidu'
    # ns.dependency 'AdsMoGo/DoMob'
    # ns.dependency 'AdsMoGo/Mobisage'
    # ns.dependency 'AdsMoGo/iAd'
  end

  s.subspec 'AdsMoGoSDK' do |as|
    as.requires_arc = false
    as.source_files = "AdsMoGoLib/AdsMoGoSDK/*.h"
    as.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'CoreLocation', 'CoreTelephony', 'MapKit', 'SystemConfiguration', 'Security', 'OpenAL', 'OpenGLES', 'EventKit', 'CoreMotion', 'AddressBookUI', 'MessageUI', 'CFNetwork', 'QuartzCore', 'iAd', 'AVFoundation', 'AddressBook', 'AudioToolbox', 'MediaPlayer', 'CoreData', 'CoreMedia', 'CoreVideo', 'ImageIO', 'MobileCoreServices', 'AdSupport', 'PassKit'
    as.libraries  = 'sqlite3', 'iconv', 'stdc++.6.0.9', 'z', 'sqlite3.0', 'xml2'
    as.vendored_libraries = 'AdsMoGoLib/AdsMoGoSDK/libAdsMogo.a', 'AdsMoGoLib/AdsMoGoSDK/libAdsMogo_i386.a'
    as.resources = ["AdsMoGoLib/AdsMoGoSDK/AdMoGoWebBrowser_ipad.xib", "AdsMoGoLib/AdsMoGoSDK/AdMoGoWebBrowser.xib", "AdsMoGoLib/AdsMoGoRes/*"]
    as.compiler_flags = '-ObjC'
  end

  s.subspec 'Baidu' do |baidus|
    baidus.requires_arc = true
    baidus.source_files = "AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/**/*.{h,m,mm,c}"
    baidus.vendored_libraries = 'AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/libBaiduMobAdSdk.a'
    baidus.resources = 'AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/baidumobadsdk.bundle'
  end

end
