//
//  AppDelegate.m
//  MoneyCollectExample
//
//  Created by 邓侃 on 2021/11/17.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "MCViewController.h"
#import <MoneyCollect/MoneyCollect.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MCViewController *VC = [[MCViewController alloc] init];
    BaseNavigationController *naV = [[BaseNavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = naV;
    [self.window makeKeyAndVisible];
    
    // 初始化 公钥 和 服务器地址
    [[MCAPIClient shared] setPublishableKey:@"Bearer test_pu_1sWrsjQP9PJiCwGsYv3risSn8YBCIEMNoVFIo8eR6s" atCustomerIPAddress:@"http://192.168.2.100:9898/api"];
    NSLog(@"测试····");
    return YES;
}


@end
