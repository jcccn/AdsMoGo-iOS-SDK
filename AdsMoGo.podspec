Pod::Spec.new do |s|
  s.name     = 'AdsMoGo'
  s.version  = '1.6.0'
  s.summary  = 'AdsMoGo is the Largest Mobile Sell-Side Platform in China.'
  s.homepage = 'https://github.com/jcccn/AdsMoGo-iOS-SDK'
  s.author   = { 'Chuncheng Jiang' => 'jccuestc@gmail.com' }
  s.license  = { :type => 'Copyright', :text => <<-LICENSE
                   © 芒果移动广告优化平台
                 LICENSE
               }
  s.source   = { :git => 'https://github.com/jcccn/AdsMoGo-iOS-SDK.git', :tag => '1.6.0' }
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.default_subspec = 'Normal'

  ### Subspecs

  s.subspec 'Normal' do |ns|
    ns.requires_arc = true
    ns.dependency 'AdsMoGo/AdsMoGoSDK'
    ns.dependency 'AdsMoGo/Baidu'
    ns.dependency 'AdsMoGo/GTD'
    ns.dependency 'AdsMoGo/iAd'
  end

  s.subspec 'AdsMoGoSDK' do |as|
    as.requires_arc = false
    as.source_files = "AdsMoGoLib/AdsMoGoSDK/*.h"
    as.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'CoreLocation', 'CoreTelephony', 'MapKit', 'SystemConfiguration', 'Security', 'OpenAL', 'OpenGLES', 'EventKit', 'EventKitUI', 'CoreMotion', 'AddressBookUI', 'MessageUI', 'CFNetwork', 'QuartzCore', 'iAd', 'AVFoundation', 'AddressBook', 'AudioToolbox', 'MediaPlayer', 'CoreData', 'CoreMedia', 'CoreVideo', 'ImageIO', 'MobileCoreServices', 'AdSupport', 'PassKit', 'Social', 'AssetsLibrary', 'StoreKit'
    as.libraries  = 'sqlite3', 'iconv', 'stdc++.6.0.9', 'z', 'sqlite3.0', 'xml2'
    as.vendored_libraries = 'AdsMoGoLib/AdsMoGoSDK/libAdsMogo.a', 'AdsMoGoLib/AdsMoGoSDK/libAdsMogo_i386.a'
    as.resources = ["AdsMoGoLib/AdsMoGoSDK/AdMoGoWebBrowser_ipad.xib", "AdsMoGoLib/AdsMoGoSDK/AdMoGoWebBrowser.xib", "AdsMoGoLib/AdsMoGoRes/*"]
    as.compiler_flags = '-ObjC'
  end

  #百度
  s.subspec 'Baidu' do |baidus|
    baidus.requires_arc = false
    baidus.dependency 'AdsMoGo/AdsMoGoSDK'
    baidus.dependency 'OpenUDID'
    baidus.dependency 'ZipArchive'
    baidus.source_files = "AdsMoGoLib/AdNetworkLibs/Baidu_3.5.6(2.4)_SDK/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Baidu_3.5.6(2.4)_SDK/lib/**/*.{h,m,mm,c}"
    baidus.exclude_files = "AdsMoGoLib/AdNetworkLibs/Baidu_3.5.6(2.4)_SDK/lib/OpenUDID/*", "AdsMoGoLib/AdNetworkLibs/Baidu_3.5.6(2.4)_SDK/lib/ZipArchive/**/*"
    baidus.vendored_libraries = 'AdsMoGoLib/AdNetworkLibs/Baidu_3.5.6(2.4)_SDK/lib/*.a'
    baidus.resources = 'AdsMoGoLib/AdNetworkLibs/Baidu_3.5.6(2.4)_SDK/lib/baidumobadsdk.bundle'
  end

  #多盟 内部编译了ZipArchive
  s.subspec 'DoMob' do |domobs|
    domobs.requires_arc = false
    domobs.dependency 'AdsMoGo/AdsMoGoSDK'
    domobs.source_files = "AdsMoGoLib/AdNetworkLibs/DoMob_SDK_456_Video_210/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/DoMob_SDK_456_Video_210/SDK/**/*.{h,m,mm,c}"
    domobs.vendored_libraries = 'AdsMoGoLib/AdNetworkLibs/DoMob_SDK_456_Video_210/SDK/libDomobSDK.a'
    domobs.resources = "AdsMoGoLib/AdNetworkLibs/DoMob_SDK_456_Video_210/SDK/Bundles/*.bundle"
  end

  #艾德思奇
  s.subspec 'Mobisage' do |mobisages|
    mobisages.requires_arc = false
    mobisages.dependency 'AdsMoGo/AdsMoGoSDK'
    mobisages.dependency 'JSONKit-NoWarning'
    mobisages.dependency 'ZipArchive'
    mobisages.source_files = "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_642/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_642/MobiSageSDK/*.{h,m,mm,c}"
    mobisages.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_642/MobiSageSDK/*.a"
    mobisages.resources = "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_642/MobiSageSDK/*.bundle"
  end

  #苹果iAd
  s.subspec 'iAd' do |iads|
    iads.requires_arc = false
    iads.dependency 'AdsMoGo/AdsMoGoSDK'
    iads.source_files = "AdsMoGoLib/AdNetworkLibs/iAd/*.{h,m}"
  end

  #百灵欧拓
  s.subspec 'o2omobi' do |o2omobis|
    o2omobis.requires_arc = false
    o2omobis.dependency 'AdsMoGo/AdsMoGoSDK'
    o2omobis.source_files = "AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_310/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_310/BalintimesO2OmobiAd/*.{h,m,mm,c}"
    o2omobis.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_310/BalintimesO2OmobiAd/*.a"
    o2omobis.resources = 'AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_310/BalintimesO2OmobiAd/BalintimesO2OmobiAd.bundle'
  end

  #谷歌AdMob
  s.subspec 'AdMob' do |admobs|
    admobs.requires_arc = false
    admobs.dependency 'AdsMoGo/AdsMoGoSDK'
    admobs.source_files = "AdsMoGoLib/AdNetworkLibs/AdMob_SDK_700/AdsMoGoAdapter/*.{h,m}"
    admobs.vendored_frameworks = "AdsMoGoLib/AdNetworkLibs/AdMob_SDK_700/GoogleMobileAds.framework"
  end

  #亿动智道
  s.subspec 'SmartMad' do |smartmads|
    smartmads.requires_arc = false
    smartmads.dependency 'AdsMoGo/AdsMoGoSDK'
    smartmads.source_files = "AdsMoGoLib/AdNetworkLibs/SmartMad_SDK_306/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/SmartMad_SDK_306/SmartMad/*.{h,m,mm,c}"
    smartmads.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/SmartMad_SDK_306/SmartMad/*.a"
    smartmads.resources = 'AdsMoGoLib/AdNetworkLibs/SmartMad_SDK_306/SmartMad/SmartMad.bundle'
  end

  #米迪
  s.subspec 'Miidi' do |miidis|
    miidis.requires_arc = false
    miidis.dependency 'AdsMoGo/AdsMoGoSDK'
    miidis.source_files = "AdsMoGoLib/AdNetworkLibs/Miidi_SDK_152/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Miidi_SDK_152/libs/XCode601/*.{h,m,mm,c}"
    miidis.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Miidi_SDK_152/libs/XCode601/*.a"
  end

  #安沃
  s.subspec 'Adwo' do |adwos|
    adwos.requires_arc = false
    adwos.dependency 'AdsMoGo/AdsMoGoSDK'
#    adwos.dependency 'ZipArchive'
    adwos.source_files = "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_660/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_660/adwoSDKLib/*.{h,m,mm,c}"
    adwos.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_660/adwoSDKLib/libAdwoSDKLib6.6.a"
    adwos.resources = "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_660/adwoSDKLib/res/*.{png,html}"
  end

  #有米
  s.subspec 'YouMi' do |youmis|
    youmis.requires_arc = false
    youmis.dependency 'AdsMoGo/AdsMoGoSDK'
    youmis.source_files = "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_501/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_501/lib/include/*.{h,m,mm,c}"
    youmis.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_501/lib/*.a"
  end

  #有米插屏
  s.subspec 'YouMiSpot' do |youmispots|
    youmispots.requires_arc = false
    youmispots.dependency 'AdsMoGo/AdsMoGoSDK'
    youmispots.source_files = "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_211_interstitial/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_211_interstitial/spotlib/include/*.{h,m,mm,c}"
    youmispots.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_211_interstitial/spotlib/*.a"
  end

  #Vpadn
  s.subspec 'Vpadn' do |vpadns|
    vpadns.requires_arc = false
    vpadns.dependency 'AdsMoGo/AdsMoGoSDK'
    vpadns.source_files = "AdsMoGoLib/AdNetworkLibs/Vpadn_SDK_428/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Vpadn_SDK_428/vpon_lib/*.{h,m,mm,c}"
    vpadns.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Vpadn_SDK_428/vpon_lib/*.a"
  end

  #Tanx(友盟)
  s.subspec 'Tanx' do |tanxs|
    tanxs.requires_arc = false
    tanxs.dependency 'AdsMoGo/AdsMoGoSDK'
    tanxs.source_files = "AdsMoGoLib/AdNetworkLibs/TANX_SDK_532/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/TANX_SDK_532/SDK/*.{h,m,mm,c}"
    tanxs.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/TANX_SDK_532/SDK/*.a"
    tanxs.resources = 'AdsMoGoLib/AdNetworkLibs/TANX_SDK_532/SDK/UMUFP.bundle'
  end

  #帷千
  s.subspec 'WeiQian' do |weiqians|
    weiqians.requires_arc = false
    weiqians.dependency 'AdsMoGo/AdsMoGoSDK'
    weiqians.dependency 'OpenUDID'
    weiqians.dependency 'ZipArchive'
    weiqians.source_files = "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_330/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_330/WQAdSDK/WQAdSDK/*.{h,m,mm,c}"
    weiqians.exclude_files = "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_330/WQAdSDK/OpenUDID/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_330/WQAdSDK/ZipArchive/**/*.{h,m}"
    weiqians.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_330/WQAdSDK/WQAdSDK/*.a"
    weiqians.resources = 'AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_330/WQAdSDK/WQAdSDK/WQADSDK.bundle'
  end

  #广点通
  s.subspec 'GTD' do |gdtmobs|
    gdtmobs.requires_arc = false
    gdtmobs.dependency 'AdsMoGo/AdsMoGoSDK'
    gdtmobs.source_files = "AdsMoGoLib/AdNetworkLibs/GDTMob_SDK_340/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/GDTMob_SDK_340/libs/*.{h,m,mm,c}"
    gdtmobs.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/GDTMob_SDK_340/libs/*.a"
  end

  #果盟
  s.subspec 'Guomob' do |guomobs|
    guomobs.requires_arc = false
    guomobs.dependency 'AdsMoGo/AdsMoGoSDK'
    guomobs.source_files = "AdsMoGoLib/AdNetworkLibs/Guomob_SDK_427/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Guomob_SDK_427/lib/GuomobAdSDK/*.{h,m,mm,c}"
    guomobs.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Guomob_SDK_427/lib/GuomobAdSDK/*.a"
    guomobs.resources = 'AdsMoGoLib/AdNetworkLibs/Guomob_SDK_427/lib/GuomobAdSDK/GuomobAdSDKBundle.bundle'
  end

  #智迅
  s.subspec 'ZhiXun' do |zhixuns|
    zhixuns.requires_arc = false
    zhixuns.dependency 'AdsMoGo/AdsMoGoSDK'
    zhixuns.source_files = "AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_330_new/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_330_new/*.{h,m,mm,c}"
    zhixuns.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_330_new/SDK/*.a"
    zhixuns.resources = 'AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_330_new/SDK/zhixun.bundle'
  end

  #传漾 内部编译了JSONKit和ZipArchive
  s.subspec 'AdsameCube' do |adsamecubes|
    adsamecubes.requires_arc = false
    adsamecubes.dependency 'AdsMoGo/AdsMoGoSDK'
    adsamecubes.source_files = "AdsMoGoLib/AdNetworkLibs/AdsameCube_SDK_105/*.{h,m}"
    adsamecubes.vendored_frameworks = 'AdsMoGoLib/AdNetworkLibs/AdsameCube_SDK_105/AdsameCubeMaxSDK.framework'
  end

  #Greystripe
  s.subspec 'Greystripe' do |greystripes|
    greystripes.requires_arc = false
    greystripes.dependency 'AdsMoGo/AdsMoGoSDK'
    greystripes.source_files = "AdsMoGoLib/AdNetworkLibs/Greystripe_SDK_400/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Greystripe_SDK_400/iOSSDK4.0/*.{h,m,mm,c}"
    greystripes.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Greystripe_SDK_400/iOSSDK4.0/*.a"
  end

end
