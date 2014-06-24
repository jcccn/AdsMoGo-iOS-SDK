Pod::Spec.new do |s|
  s.name     = 'AdsMoGo'
  s.version  = '1.4.8'
  s.summary  = 'AdsMoGo is the Largest Mobile Sell-Side Platform in China.'
  s.homepage = 'https://github.com/jcccn/AdsMoGo-iOS-SDK'
  s.author   = { 'Chuncheng Jiang' => 'jccuestc@gmail.com' }
  s.license  = { :type => 'Copyright', :text => <<-LICENSE
                   © 芒果移动广告优化平台
                 LICENSE
               }
  s.source   = { :git => 'https://github.com/jcccn/AdsMoGo-iOS-SDK.git', :tag => '1.4.8' }
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.default_subspec = 'Normal'

  ### Subspecs

  s.subspec 'Normal' do |ns|
    ns.requires_arc = true
    ns.dependency 'AdsMoGo/AdsMoGoSDK'
    ns.dependency 'AdsMoGo/Baidu'
    ns.dependency 'AdsMoGo/DoMob'
    ns.dependency 'AdsMoGo/Mobisage'
    ns.dependency 'AdsMoGo/iAd'
  end

  s.subspec 'AdsMoGoSDK' do |as|
    as.requires_arc = false
    as.source_files = "AdsMoGoLib/AdsMoGoSDK/*.h"
    as.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'CoreLocation', 'CoreTelephony', 'MapKit', 'SystemConfiguration', 'Security', 'OpenAL', 'OpenGLES', 'EventKit', 'CoreMotion', 'AddressBookUI', 'MessageUI', 'CFNetwork', 'QuartzCore', 'iAd', 'AVFoundation', 'AddressBook', 'AudioToolbox', 'MediaPlayer', 'CoreData', 'CoreMedia', 'CoreVideo', 'ImageIO', 'MobileCoreServices', 'AdSupport', 'PassKit', 'Social', 'AssetsLibrary', 'StoreKit'
    as.libraries  = 'sqlite3', 'iconv', 'stdc++.6.0.9', 'z', 'sqlite3.0', 'xml2'
    as.vendored_libraries = 'AdsMoGoLib/AdsMoGoSDK/libAdsMogo.a', 'AdsMoGoLib/AdsMoGoSDK/libAdsMogo_i386.a'
    as.resources = ["AdsMoGoLib/AdsMoGoSDK/AdMoGoWebBrowser_ipad.xib", "AdsMoGoLib/AdsMoGoSDK/AdMoGoWebBrowser.xib", "AdsMoGoLib/AdsMoGoRes/*"]
    as.compiler_flags = '-ObjC'
  end

  #百度
  s.subspec 'Baidu' do |baidus|
    baidus.requires_arc = false
    baidus.dependency 'AdsMoGo/AdsMoGoSDK'
#    baidus.dependency 'OpenUDID'
#    baidus.dependency 'ZipArchive'
    baidus.source_files = "AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/**/*.{h,m,mm,c}"
    baidus.exclude_files = "AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/OpenUDID/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/ZipArchive/**/*.{h,m}"
    baidus.vendored_libraries = 'AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/libBaiduMobAdSdk.a'
    baidus.resources = 'AdsMoGoLib/AdNetworkLibs/Baidu_3.4.7_SDK/lib/baidumobadsdk.bundle'
  end

  #多盟 内部编译了ZipArchive
  s.subspec 'DoMob' do |domobs|
    domobs.requires_arc = false
    domobs.dependency 'AdsMoGo/AdsMoGoSDK'
    domobs.source_files = "AdsMoGoLib/AdNetworkLibs/DoMob_SDK_429/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/DoMob_SDK_429/DomobAdSDK/**/*.{h,m,mm,c}"
    domobs.vendored_libraries = 'AdsMoGoLib/AdNetworkLibs/DoMob_SDK_429/DomobAdSDK/libDomobAdSDK.a'
    domobs.resources = 'AdsMoGoLib/AdNetworkLibs/DoMob_SDK_429/DomobAdSDK/DomobAdSDKBundle/DomobAdSDKBundle.bundle'
  end

  #艾德思奇
  s.subspec 'Mobisage' do |mobisages|
    mobisages.requires_arc = false
    mobisages.dependency 'AdsMoGo/AdsMoGoSDK'
    mobisages.dependency 'JSONKit-NoWarning'
#    mobisages.dependency 'ZipArchive'
    mobisages.source_files = "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_620/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_620/*.{h,m,mm,c}"
    mobisages.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Mobisage_SDK_620/*.a"
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
    o2omobis.source_files = "AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_202/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_202/BalintimesO2OmobiAd/*.{h,m,mm,c}"
    o2omobis.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_202/BalintimesO2OmobiAd/*.a"
    o2omobis.resources = 'AdsMoGoLib/AdNetworkLibs/o2omobi_SDK_202/BalintimesO2OmobiAd/BalintimesO2OmobiAd.bundle'
  end

  #谷歌AdMob
  s.subspec 'AdMob' do |admobs|
    admobs.requires_arc = false
    admobs.dependency 'AdsMoGo/AdsMoGoSDK'
    admobs.source_files = "AdsMoGoLib/AdNetworkLibs/AdMob_SDK_692/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/AdMob_SDK_692/*.{h,m,mm,c}"
    admobs.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/AdMob_SDK_692/*.a"
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
    miidis.source_files = "AdsMoGoLib/AdNetworkLibs/Miidi_SDK_145/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Miidi_SDK_145/Lib/*.{h,m,mm,c}"
    miidis.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Miidi_SDK_145/Lib/*.a"
  end

  #安沃
  s.subspec 'Adwo' do |adwos|
    adwos.requires_arc = false
    adwos.dependency 'AdsMoGo/AdsMoGoSDK'
#    adwos.dependency 'ZipArchive'
    adwos.source_files = "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_610/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_610/adwoSDKLib/adwoSDK/*.{h,m,mm,c}"
    adwos.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_610/adwoSDKLib/adwoSDK/libAdwoSDK6.1.a"
    adwos.resources = "AdsMoGoLib/AdNetworkLibs/Adwo_SDK_610/adwoSDKLib/adwoSDK/res/*.{png,html}"
    adwos.vendored_frameworks = 'AdsMoGoLib/AdNetworkLibs/Adwo_SDK_610/adwoSDKLib/adwoSDK/iflyMSC.framework'
  end

  #有米
  s.subspec 'YouMi' do |youmis|
    youmis.requires_arc = false
    youmis.dependency 'AdsMoGo/AdsMoGoSDK'
    youmis.source_files = "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_510/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_510/include/*.{h,m,mm,c}"
    youmis.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/YouMi_SDK_510/*.a"
  end

  #Vpon
  s.subspec 'Vpon' do |vpons|
    vpons.requires_arc = false
    vpons.dependency 'AdsMoGo/AdsMoGoSDK'
    vpons.source_files = "AdsMoGoLib/AdNetworkLibs/Vpon_SDK_427/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Vpon_SDK_427/vpon_lib/*.{h,m,mm,c}"
    vpons.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Vpon_SDK_427/vpon_lib/*.a"
  end

  #友盟
  s.subspec 'UM' do |ums|
    ums.requires_arc = false
    ums.dependency 'AdsMoGo/AdsMoGoSDK'
    ums.source_files = "AdsMoGoLib/AdNetworkLibs/UM_SDK_490/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/UM_SDK_490/SDK/*.{h,m,mm,c}"
    ums.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/UM_SDK_490/SDK/*.a"
    ums.resources = 'AdsMoGoLib/AdNetworkLibs/UM_SDK_490/SDK/UMUFP.bundle'
  end

  #帷千
  s.subspec 'WeiQian' do |weiqians|
    weiqians.requires_arc = false
    weiqians.dependency 'AdsMoGo/AdsMoGoSDK'
#    weiqians.dependency 'OpenUDID'
#    weiqians.dependency 'ZipArchive'
    weiqians.source_files = "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_313/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_313/WQAdSDK/WQAdSDK/*.{h,m,mm,c}"
    weiqians.exclude_files = "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_313/WQAdSDK/OpenUDID/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_313/WQAdSDK/ZipArchive/**/*.{h,m}"
    weiqians.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_313/WQAdSDK/WQAdSDK/*.a"
    weiqians.resources = 'AdsMoGoLib/AdNetworkLibs/WeiQian_SDK_313/WQAdSDK/WQAdSDK/WQADSDK.bundle'
  end

  #触控
  s.subspec 'PuchBox' do |puchboxs|
    puchboxs.requires_arc = false
    puchboxs.dependency 'AdsMoGo/AdsMoGoSDK'
    puchboxs.source_files = "AdsMoGoLib/AdNetworkLibs/PuchBox_SDK_421/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/PuchBox_SDK_421/libPunchBoxAd/*.{h,m,mm,c}"
    puchboxs.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/PuchBox_SDK_421/libPunchBoxAd/*.a"
    puchboxs.resources = 'AdsMoGoLib/AdNetworkLibs/PuchBox_SDK_421/libPunchBoxAd/PunchBoxAdRes.bundle'
  end

  #果盟
  s.subspec 'Guomob' do |guomobs|
    guomobs.requires_arc = false
    guomobs.dependency 'AdsMoGo/AdsMoGoSDK'
    guomobs.source_files = "AdsMoGoLib/AdNetworkLibs/Guomob_SDK_335/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Guomob_SDK_335/*.{h,m,mm,c}"
    guomobs.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Guomob_SDK_335/*.a"
    guomobs.resources = 'AdsMoGoLib/AdNetworkLibs/Guomob_SDK_335/GuomobAdSDKBundle.bundle'
  end

  #智迅
  s.subspec 'ZhiXun' do |zhixuns|
    zhixuns.requires_arc = false
    zhixuns.dependency 'AdsMoGo/AdsMoGoSDK'
    zhixuns.source_files = "AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_320/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_320/*.{h,m,mm,c}"
    zhixuns.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_320/SDK/*.a"
    zhixuns.resources = 'AdsMoGoLib/AdNetworkLibs/ZhiXun_SDK_320/SDK/zhixun.bundle'
  end

  #传漾 内部编译了JSONKit和ZipArchive
  s.subspec 'AdsameCube' do |adsamecubes|
    adsamecubes.requires_arc = false
    adsamecubes.dependency 'AdsMoGo/AdsMoGoSDK'
    adsamecubes.source_files = "AdsMoGoLib/AdNetworkLibs/AdsameCube_SDK_105/*.{h,m}"
    adsamecubes.vendored_frameworks = 'AdsMoGoLib/AdNetworkLibs/AdsameCube_SDK_105/AdsameCubeMaxSDK.framework'
  end

  #众感传媒 有错：ptqfp找不到
  s.subspec 'iisense' do |iisenses|
    iisenses.requires_arc = false
    iisenses.dependency 'AdsMoGo/AdsMoGoSDK'
    iisenses.source_files = "AdsMoGoLib/AdNetworkLibs/iisense_SDK_221/AdsMoGoAdapter/*.{h,m}"
    iisenses.vendored_frameworks = 'AdsMoGoLib/AdNetworkLibs/iisense_SDK_221/SNMAd.framework'
    iisenses.resources = 'AdsMoGoLib/AdNetworkLibs/iisense_SDK_221/MRAID.bundle'
  end

  #Greystripe
  s.subspec 'Greystripe' do |greystripes|
    greystripes.requires_arc = false
    greystripes.dependency 'AdsMoGo/AdsMoGoSDK'
    greystripes.source_files = "AdsMoGoLib/AdNetworkLibs/Greystripe_SDK_400/AdsMoGoAdapter/*.{h,m}", "AdsMoGoLib/AdNetworkLibs/Greystripe_SDK_400/iOSSDK4.0/*.{h,m,mm,c}"
    greystripes.vendored_libraries = "AdsMoGoLib/AdNetworkLibs/Greystripe_SDK_400/iOSSDK4.0/*.a"
  end

end
