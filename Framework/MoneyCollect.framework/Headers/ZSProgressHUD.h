//
//  ZSProgressHUD.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZSHUDType) {
     ZSHUDLoadingType,//加载中
     ZSHUDSuccessfulAnimatedType,//加载成功动画
     ZSHUDErrorAnimatedType,//加载错误动画
     ZSHUDpromptTextType,//提示文字
};


@interface ZSProgressHUD : UIView

@property (nonatomic,strong) NSString *tipText;
@property(nonatomic,strong)  UILabel * showTextLabel;
@property (nonatomic,strong) UIView *toast;
@property(nonatomic,assign)  ZSHUDType type;

- (void)show:(BOOL)animated view:(UIView *)view;

- (void)hide:(BOOL)animated view:(UIView *)view;

- (instancetype)initWithFrame:(CGRect)frame showText:(NSString *)showText HUDType:(ZSHUDType)type;
///加载类型
+ (instancetype)showHUDShowText:(NSString *)showText;
//加载成功提示
+ (instancetype)showSuccessfulAnimatedText:(NSString *)ShowText;
//错误提示
+ (instancetype)showErrorAnimatedText:(NSString *)ShowText;
//文字提示
+ (instancetype)showDpromptText:(NSString *)showText;
//隐藏
+ (NSUInteger)hideAllHUDAnimated:(BOOL)animated;


@end
