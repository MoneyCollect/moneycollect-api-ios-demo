//
//  MCDefineHeader.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/9/28.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#ifndef MCDefineHeader_h
#define MCDefineHeader_h


#endif /* MCDefineHeader_h */


//**************************************** 屏幕大小 *************************************************
//屏幕宽度
#define SCREEN_WIDTH      [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
//大小
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
//判断是 加载2x图还是3x图 屏幕 (2:加载2x、3:加载3x)
#define kScreenScale [UIScreen mainScreen].scale

//************************ 不同屏幕尺寸字体适配 **********************************************
#define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
//#define kScreenHeightRatio  (UIScreen.mainScreen.bounds.size.height / 667.0)
#define kScreenHeightRatio  (iPhoneX ? ((UIScreen.mainScreen.bounds.size.height - 145.0) / 667.0) : (UIScreen.mainScreen.bounds.size.height / 667.0))
#define AdaptedWidth(W)  ceilf((W) * kScreenWidthRatio)
#define AdaptedHeight(H) ceilf((H) * kScreenHeightRatio)
#define AdaptedFontSize(R)     [UIFont systemFontOfSize:AdaptedWidth(R)]


#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


//顶部电池栏的高度              (iPhoneX ? 44.0 : 20.0)
#define TopStatusBarH       [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏的高度                (iPhoneX ? 44.0 : 44.0)
#define NavigationBarH      self.navigationController.navigationBar.frame.size.height
//                          (iPhoneX ? 88.0 : 64.0)
#define NavigationHeight    (TopStatusBarH + NavigationBarH)
//底部分栏控制器的高度          (iPhoneX ? 83.0 : 49.0)
#define BottomTabBarH       self.tabBarController.tabBar.frame.size.height

//顶部电池栏的高度
#define KTopStatusBarH      (iPhoneX ? 44.0 : 20.0)

//状态栏高度+导航栏高度
#define kNavBarHeight       (iPhoneX ? 88.0 : 64.0)

//底部安全区域高度
#define BottomSafeAreaHeight  (iPhoneX ? 34.0 : 0)
//底部分栏控制器的高度
#define UMBottomTabBarHeight    (iPhoneX ? 83.0 : 49.0)


//************************************ 字体 **********************************************
//常规字体
//
#define Font_Bold(R)           [UIFont fontWithName:@"PingFangSC-Semibold" size:R * kScreenWidthRatio]
//
#define Font_Regular(R)          [UIFont fontWithName:@"PingFangSC-Regular" size:R * kScreenWidthRatio]


//************************************ 加载资源文件 **********************************************
#define ResoursBundle     [NSBundle ab_Bundle]

// SDK国际化加载
#define MCLocalizedString(String)    [NSBundle localizedStringForKey:String]

// SDK图片加载
#define MCImgName(ImageNameString)    [UIImage imageNamed:(ImageNameString) inBundle:ResoursBundle compatibleWithTraitCollection:nil]


// 判断SDK版本号
//#define isV_2_1  [ABPaySDK_Version isEqualToString:@"2.1.0"]



//************************** 打印 (NSLog) *******************************************
#ifdef DEBUG // 调试状态, 打开LOG功能
#define NSLog( s, ... ) printf("类名: <%s>: 第 %d 行  方法: %s %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] )
#else// 发布状态, 关闭LOG功能
#define NSLog( s, ... )
#endif
