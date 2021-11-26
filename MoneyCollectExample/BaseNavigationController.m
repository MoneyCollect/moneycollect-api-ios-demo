//
//  BaseNavigationController.m
//

#import "BaseNavigationController.h"

//随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface BaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    // 统一设置导航条上的字体大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [navBar setTitleTextAttributes:attrs];
    
    //统一设置导航条上的背景图片
    [navBar setBackgroundImage:[self createImageWithColor:RandomColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    // 去除导航分割线
    navBar.shadowImage = [UIImage new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开启系统侧滑返回
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //非根控制器时
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 重写这个方法,让控制器动态的修改状态栏颜色
- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.topViewController;
}

//根据颜色值去绘制一张图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
