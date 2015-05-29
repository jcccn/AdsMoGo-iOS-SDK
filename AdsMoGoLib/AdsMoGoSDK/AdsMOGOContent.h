//
//  AdsMOGOContent.h
//  wanghaotest
//
//  Created by Castiel Chen on 15/5/12.
//
//

#import <Foundation/Foundation.h>



typedef enum : NSUInteger {
    //图书
    CatTypeBookReasoning =1 , //图书_推理侦探悬疑
    CatTypeBookHorror = 2 ,    //图书_恐怖惊悚
    CatTypeBookRomance  =3 , 	//图书_言情（古代、现代）
    CatTypeBookHistory	=4 ,	//	图书_历史架空穿越
    CatTypeBookCareer_Story =5 ,//	图书_职场商战
    CatTypeBookOfficialdom=6 ,	//	图书_官场政治
    CatTypeBookMilitary	=7 ,	//图书_军事战争
    CatTypeBookFantasy		=8 ,	//图书_玄幻灵异
    CatTypeBookScience_Fiction 	=9 ,//图书_科幻
    CatTypeBookMartial_Arts_Novels =10 ,// 图书_武侠
    CatTypeBookYouth =11 , //图书_青春校园
    CatTypeBookLesbian =12 ,// 图书_同人耽美
    CatTypeBookChineseClassics =13 , //图书_中国古典名著
    CatTypeBookWorldClassics=14 , // 图书_世界名著
    CatTypeBookLifeKnowledge=15 ,   //图书_生活百科
    CatTypeBookSocial_Science =16 , //图书_社会科学
    CatTypeBookCartoon  =17 ,		//图书_动漫绘画
    CatTypeBookPhilosophy=18 ,   //图书_哲学宗教
    CatTypeBookMarriage=19 ,  	//图书_两性婚恋
    CatTypeBookFinancing=21 ,  //图书_经济管理、投资理财
    CatTypeBookPsychology=22 ,  //图书_心理学
    CatTypeBookChildren_Education=23 ,//图书_少儿教育
    CatTypeBookParenting_Knowledge=24 , //图书_孕产育儿
    CatTypeBookTravel=25 ,  //图书_旅游探险
    CatTypeBookCooking=26 ,  //图书_美食烹饪
    CatTypeBookHealth_Care=27 , //图书_养生保健
    CatTypeBookFashion=28 ,  //图书_时尚美容
    CatTypeBookHomeDecoration=29 ,  //图书_家居装饰
    CatTypeBookExamination=30 ,  //图书_教辅考试
    CatTypeBookForeignLanguage=31 , //图书_外语
    CatTypeBookDictionary=32,  //图书_辞典工具书
    CatTypeBookMotivationalBook=33 , //图书_成功励志
    CatTypeBookMedicalScience=34 , //图书_医学
    CatTypeBookScience=35 ,  //图书_科学技术
    CatTypeBookComputer=36 ,  //图书_计算机与互联网
    CatTypeBookArt=37,  //图书_艺术摄影
    CatTypeBookSports=38, //图书_体育
    CatTypeBookEntertainment=39 , //图书_娱乐休闲
    CatTypeBookJournal=40,  //图书_期刊杂志
    // 听书
    CatTypeListenBookCurrentPolitics=41,  //听书_时政热点
    CatTypeListenBookAudiobooks=42,  //听书_有声小说
    CatTypeListenBookLiterature=43,  //听书_文学名著
    CatTypeListenBookChinese_Opera=44,  //听书_曲艺戏曲
    CatTypeListenBookPop_Music=45,  //听书_潮流音乐
    CatTypeListenBookCrosstalk=46,  //听书_相声评书
    CatTypeListenBookKid=47,  //听书_少儿天地
    CatTypeListenBookForeignLanguage=48,  //听书_外语学习
    CatTypeListenBookEntertainment=49,  //听书_娱乐综艺
    CatTypeListenBookHumanities=50,  //听书_人文社科
    CatTypeListenBookCommerce=51,  //听书_商业财经
    CatTypeListenBookIT=52,  //听书_IT科技
    CatTypeListenBookProfessionalSkills=53,  //听书_职业技能
    CatTypeListenBookFanmusic=54,  //听书_纯乐梵音
    CatTypeListenBookHealthCare=55,  //听书_健康养生
    CatTypeListenBookFashionLifestyle=56,  //听书_时尚生活
    CatTypeListenBookEmotionalSubject=57,  //听书_情感话题
    CatTypeListenBookRadioPlay=58,  //听书_广播剧
    CatTypeListenBookRadioPrograms=59,  //听书_电台
    CatTypeListenBookLectureRoom=60,  //听书_百家讲坛
    CatTypeListenBookOthers=61,  //听书_其他
  
  //新闻
    CatTypeNewsCurrent_Politics_And_Hotspot=62,    //新闻_时政要闻,
    CatTypeNewsFinance = 63,    //新闻_财经
    CatTypeNewsMilitary = 64,   //新闻_军事
    CatTypeNewsHistory = 65,    //新闻_历史
    CatTypeNewsSociety = 66,    //新闻_社会
    CatTypeNewsScience = 67,    //新闻_科技
    CatTypeNewsCulture = 68,    //新闻_文化
    CatTypeNewsSports = 69,     //新闻_体育
    CatTypeNewsEntertainment = 70,  //新闻_娱乐
    CatTypeNewsEncyclopedia = 81,   //新闻_百科
    CatTypeNewsStocks    = 71,      //新闻_股票
    CatTypeNewsAutomobile = 72,     // 新闻_汽车
    CatTypeNewsReal_Estate = 73,    // 新闻_房产
    CatTypeNewsEducation = 74,      // 新闻_教育
    CatTypeNewsDigital_Products = 75,// 新闻_数码
    CatTypeNewsWoman = 76,  //新闻_女性
    CatTypeNewsForum = 77,  //新闻_论坛
    CatTypeNewsVideo = 78,  //新闻_视频
    CatTypeNewsTravel = 79, //新闻_旅游
    CatTypeNewsHome_Furnishings = 80,   //新闻_家居
    CatTypeNewsGames=82,    //新闻_游戏
    CatTypeNewsHealth = 83, //新闻_健康
    CatTypeNewsCity = 84,   //新闻_城市
    CatTypeNewsCharity = 85,    //新闻_公益
    CatTypeNewsConstellation = 86,  //新闻_星座
    CatTypeNewsLottery = 87,    //新闻_彩票
    CatTypeNewsOthers = 88, //新闻_其他
  
  
  //视频
    CatTypeVideoTv_Play=89,       //视频_娱乐,
    CatTypeVideoMovie=90,         //视频_电影,
    CatTypeVideoVariety_Show=91,  //视频_综艺,
    CatTypeVideoMusic=92,         //视频_音乐,
    CatTypeVideoDocumentary=93,   //视频_纪录片,
    CatTypeVideoCartoon=94,       //视频_动漫,
    CatTypeVideoEducation=95,     //视频_教育,
    CatTypeVideoSports=96,        //视频_体育,
    CatTypeVideoFinance=97,       //视频_财经,
    CatTypeVideoInformation=98,   //视频_资讯,
    CatTypeVideoEntertainment=99, //视频_娱乐,
    CatTypeVideoAutomobile=100,   //视频_汽车,
    CatTypeVideoTechnology=101,   //视频_科技,
    CatTypeVideoLife=102,         //视频_生活,
    CatTypeVideoGames=103,        //视频_游戏,
    CatTypeVideoFashion=104,      //视频_时尚,
    CatTypeVideoTravel=105,       //视频_旅游,
    CatTypeVideoParent_Child=106, //视频_亲子,
    CatTypeVideoComedy = 107,     //视频_搞笑,
    CatTypeVideoMicro_Movie = 108,//视频_微电影,
    CatTypeVideoInternet_Drama = 109,   //视频_网剧,
    CatTypeVideoFlickr = 110,           //视频_拍客,
    CatTypeVideoInitiative_Video = 111, //视频_创意视频,
    CatTypeVideoAdvertisement = 112,    //视频_广告
    CatTypeVideoOthers = 113,           //视频_其他
    
  
} CatType;

@interface AdsMOGOContent : NSObject
@property(retain,nonatomic)NSString * title;
@property(retain,nonatomic)NSString * url;
+(AdsMOGOContent*)shareSingleton;
//设置类别
-(void)setCatType:(CatType)catType,... NS_REQUIRES_NIL_TERMINATION;
-(void)setkeyWords:(NSString*)keywords, ... NS_REQUIRES_NIL_TERMINATION;




/**
 *  cocos2d-x 提供的方法
 *
 */
-(void)setCatTypeCocos2dx:(NSString*)str;
-(void)setkeyWordsCocos2dx:(NSString*)str;





@end
