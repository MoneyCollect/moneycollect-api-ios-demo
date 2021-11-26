//
//  MCSelectPaymentCardVC.m
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/11.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCSelectPaymentCardVC.h"
#import "MCPresentationController.h"
#import <MoneyCollect/MoneyCollect.h>
#import "MCThreeDSWebViewController.h"


/** 选择卡的高度 */
#define SelectPaymentCard_Height AdaptedHeight(54 + 60 + 130) + 5
/** 添加卡View的高度 */
#define AddCardContentViewHeight AdaptedHeight(73 + 50 + 10 + 110 + 10 + 110 + 10 + 30 + 130)

@interface MCSelectPaymentCardVC ()<MCSelectPaymentCardViewDelegate,MCAddPaymentCardViewDelegate>
/** 选择卡支付View */
@property (nonatomic,strong) MCSelectPaymentCardView *selectPaymentCardView;
/** 添加支付View */
@property (nonatomic,strong) MCAddPaymentCardView *addPaymentCardView;
/** 记录高度 */
@property (nonatomic,assign) CGFloat lastHeight;
/** 数据源 */
@property (nonatomic,strong) NSArray *dataSource;
/** （交易成功的数据）交易成功时,才把后台返回的数据给传出去 */
@property (nonatomic,strong) NSDictionary *responseObject;


@end

@implementation MCSelectPaymentCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContentView];
    
}

#pragma mark - 设置内容View
- (void)setContentView
{
    self.view.backgroundColor = [UIColor whiteColor];
    //切圆角
    [self.view cuttingViewbyRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadiusWidth:AdaptedWidth(10)];
    
    // 提示框
    [ZSProgressHUD showHUDShowText:@""];
    // 获取卡列表
    __weak typeof(self) weakSelf = self;
    [[MCAPIClient shared] getCustomersPaymentMethodsAtCustomerId:_customerID completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            NSArray *data = [responseObject objectForKey:@"data"];
            weakSelf.dataSource = data;
            
            if (weakSelf.dataSource.count) { // 有数据
                // 要增加的高度 (动画高度)
                CGFloat alertAnimateHeight = (data.count - 1) * AdaptedHeight(60) + AdaptedHeight(40) + AdaptedHeight(60);
                //如果卡片比较多,一屏展示不完,就最多展示一屏
                CGFloat H = SelectPaymentCard_Height; // alertView 的原始高度
                CGFloat MAX_HEIGHT = SCREEN_HEIGHT - KTopStatusBarH; // 展示的最大高度
                if ((H + alertAnimateHeight) > MAX_HEIGHT) {  // 一屏显示不完,需要滚动
                    alertAnimateHeight = MAX_HEIGHT - H;
                }
                
                // 设置内容的高度
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.view.y = SCREEN_HEIGHT - (SelectPaymentCard_Height + alertAnimateHeight);
                    weakSelf.view.height = SelectPaymentCard_Height + alertAnimateHeight;
                }];
                
            }else { // 没有数据
                
                // 设置内容的高度
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.view.y = SCREEN_HEIGHT - SelectPaymentCard_Height;
                    weakSelf.view.height = SelectPaymentCard_Height;
                }];
            }
            
        }else { // 请求失败
            
            // 设置内容的高度
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.view.y = SCREEN_HEIGHT - SelectPaymentCard_Height;
                weakSelf.view.height = SelectPaymentCard_Height;
            }];
            
            NSLog(@"获取卡列表失败,code = %ld 错误信息 = %@",(long)error.code,error.localizedDescription);
        }
        
        [weakSelf.view addSubview:weakSelf.selectPaymentCardView];
    }];
}

#pragma mark - 懒加载UI
- (MCSelectPaymentCardView *)selectPaymentCardView
{
    if (!_selectPaymentCardView) {
        _selectPaymentCardView = [[MCSelectPaymentCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
        _selectPaymentCardView.dataSource = _dataSource;
        _selectPaymentCardView.delegate = self;
    }
    return _selectPaymentCardView;
}

- (MCAddPaymentCardView *)addPaymentCardView
{
    if (!_addPaymentCardView) {
        _addPaymentCardView = [[MCAddPaymentCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AddCardContentViewHeight)];
        _addPaymentCardView.titleStr = MCLocalizedString(@"Add you payment information");
        _addPaymentCardView.delegate = self;
    }
    return _addPaymentCardView;
}

#pragma mark - 设置数据源
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    if ([_dataSource isKindOfClass:[NSNull class]]) { // 数据为空,后台返回为 null 类型,重新初始化一下
        _dataSource = [NSArray array];
    }
}

#pragma mark - 返回
- (void)back
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 添加保存卡
- (void)addSaveCard:(UITapGestureRecognizer *)tap
{
    // 移除 选择卡 View
    [self.selectPaymentCardView removeFromSuperview];
    
    // 加载 添加卡的View
    [self.view addSubview:self.addPaymentCardView];
    
    // 记录高度
    _lastHeight = self.view.height;
    
    __weak typeof(self) weakSelf = self;
    // 调整 内容大小
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.view.y = SCREEN_HEIGHT - AddCardContentViewHeight;
        weakSelf.view.height = AddCardContentViewHeight;
        
    }];
}

#pragma mark - AddPaymentCardView返回
- (void)AddPaymentCardViewBack
{
    // 移除 添加卡 view
    [self.addPaymentCardView removeFromSuperview];
    // 释放内存,防止强引用
    self.addPaymentCardView = nil;
    
    // 添加 选择卡 View
    [self.view addSubview:self.selectPaymentCardView];
    
    // 调整 内容大小
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.view.y = SCREEN_HEIGHT - weakSelf.lastHeight;
        weakSelf.view.height = weakSelf.lastHeight;
        
    }];
}

#pragma mark - 弹出视图
- (void)present:(UIViewController *)viewController
{
    // 做一下判空处理
    if (!_customerID.length) { // 商户没有传 customerID
        [ZSProgressHUD showDpromptText:@"customer id is empty"];
        return;
    }
    
    MCPresentationController *presentationVC = [[MCPresentationController alloc] initWithPresentedViewController:self presentingViewController:viewController];

    // 指定自定义modal动画的代理
    self.transitioningDelegate = presentationVC;
    
    [viewController presentViewController:self animated:YES completion:nil];
    
}

#pragma mark - 关闭视图
- (void)dismiss
{
    // 打开手势 点击
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = YES;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 支付 (Pay Now)
- (void)payNowClick:(NSDictionary *)paymentMethodParams
{
    [self payNow:paymentMethodParams atSetupFutureUsage:@"off"];
}

#pragma mark - 添加支付 (Add your payment information)
- (void)addPayNowClick:(MCPaymentMethodParams *)paymentMethodParams atIsSelected:(BOOL)isSelected
{
    // 1.创建支付方式
    paymentMethodParams.billingDetails.address = _billingDetails.address;
    paymentMethodParams.billingDetails.phone = _billingDetails.phone;
    
    __weak typeof(self) weakSelf = self;
    [[MCAPIClient shared] createPaymentMethodWithParams:paymentMethodParams completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
          
        if (!error) { // 请求成功
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) { // 创建支付方式成功
                
                NSDictionary *params = [responseObject objectForKey:@"data"];
                
                NSString *setupFutureUsage = isSelected ? @"on" : @"off";
                
                [weakSelf payNow:params atSetupFutureUsage:setupFutureUsage];
                
            }else {
                [weakSelf requestCompleted:[responseObject objectForKey:@"msg"]];
            }
            
        }else { // 失败
            [weakSelf requestCompleted:error.localizedDescription];
            NSLog(@"创建支付方式失败,code = %ld 错误信息 = %@",(long)error.code,error.localizedDescription);
        }
    }];
}

- (void)payNow:(NSDictionary *)paymentMethodParams atSetupFutureUsage:(NSString *)setupFutureUsage
{
    // 补齐一些参数
    _createPaymentParams.customerId = _customerID;
    _createPaymentParams.paymentMethod = [paymentMethodParams objectForKey:@"id"];
    _createPaymentParams.setupFutureUsage = setupFutureUsage;
    
    __weak typeof(self) weakSelf = self;
    [[MCAPIClient shared] createPaymentWithParams:_createPaymentParams completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
          
        if (!error) { // 请求成功
            
            NSString *code = [responseObject objectForKey:@"code"];
            
            if ([code isEqualToString:@"success"]) { // 创建支付方式成功（提交交易订单）
                
                NSDictionary *data = [responseObject objectForKey:@"data"];
                
                MCConfirmPaymentParams *params = [[MCConfirmPaymentParams alloc] init];
                params.amount = [data objectForKey:@"amount"];
                params.currency = [data objectForKey:@"currency"];
                params.paymentID = [data objectForKey:@"id"];
                params.notifyUrl = [data objectForKey:@"notifyUrl"];
                params.paymentMethod = [data objectForKey:@"paymentMethod"];
                params.receiptEmail = [data objectForKey:@"receiptEmail"];
                params.returnUrl = [data objectForKey:@"returnUrl"];
                params.setupFutureUsage = [data objectForKey:@"setupFutureUsage"];
                params.clientSecret = [data objectForKey:@"clientSecret"];
                
                params.shipping = weakSelf.createPaymentParams.shipping;
                params.website = @"https://baidu.com";
                
                [[MCAPIClient shared] confirmPaymentWithParams:params completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                
                    if (!error) { // 请求成功
                        
                        // 判断是否走 3D
                        NSDictionary *nextAction = [[responseObject objectForKey:@"data"] objectForKey:@"nextAction"];
                        
                        if (nextAction) { // 这个对象存在的话说明要走 3D 验证
                            
                            NSString *redirectToUrl = [nextAction objectForKey:@"redirectToUrl"];
                            NSString *paymentID = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                            NSString *clientSecret = [[responseObject objectForKey:@"data"] objectForKey:@"clientSecret"];
                            
                            // 加载 3D 页面
                            MCThreeDSWebViewController *threeDSVC = [[MCThreeDSWebViewController alloc] init];
                            [threeDSVC loadURL:redirectToUrl paymentID:paymentID clientSecret:clientSecret];
                    
                            // msg:状态   responseObject:检索Payment(retrievePayment)接口后台返回数据
                            threeDSVC.completeBlock = ^(NSString *msg, NSDictionary *responseObject){
                                
                                // 消除动画
                                [weakSelf requestCompleted:msg];
                                weakSelf.responseObject = responseObject;
                                
                            };
        
                            [weakSelf presentViewController:threeDSVC animated:YES completion:nil];
                            
                        }else { // 普通交易
                            
                            // 交易状态
                            NSString *status = [[responseObject objectForKey:@"data"] objectForKey:@"status"];
                            // 提示语
                            NSString *msg = @"";
                            
                            if ([status isEqualToString:@"succeeded"]) {
                                
                                msg = @"success";
                                weakSelf.responseObject = responseObject;
                                
                            }else if ([status isEqualToString:@"failed"]) {
                                
                                msg = [[responseObject objectForKey:@"data"] objectForKey:@"errorMessage"];
                                
                            }else if ([status isEqualToString:@"pending"]) {
                                
                                msg = @"the payment is pending";
                                
                            }else if ([status isEqualToString:@"uncaptured"]) {
                                
                                msg = @"the payment is uncaptured";
                                
                            }else if ([status isEqualToString:@"canceled"]) {
                                
                                msg = @"the payment is canceled";
                                
                            }else {
                                
                                msg = @"the payment is pending";
                                
                            }
                            
                            // 消除动画
                            [weakSelf requestCompleted:msg];
                            
                        }
                    
                        NSLog(@"确认扣款:%@",responseObject);
                        
                    }else { // 请求失败
                        
                        // 消除动画
                        [weakSelf requestCompleted:error.localizedDescription];
                        
                        NSLog(@"确认支付（确认扣款）失败,code = %ld 错误信息 = %@",(long)error.code,error.localizedDescription);
                    }
                                
                }];
                
            }else { // 创建支付方式失败
                
                // 消除动画
                [weakSelf requestCompleted:[responseObject objectForKey:@"msg"]];
            }
            
        }else { // 请求失败
            
            // 消除动画
            [weakSelf requestCompleted:error.localizedDescription];
            
            NSLog(@"创建支付（提交交易订单）失败,code = %ld 错误信息 = %@",(long)error.code,error.localizedDescription);
        }
        
    }];
}

#pragma mark - 接口请求完成
- (void)requestCompleted:(NSString *)msg
{
    __weak typeof(self) weakSelf = self;
    if ([msg isEqualToString:@"success"]) { // 请求成功
    
        // 销毁弹框
        // 延迟2s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 把交易成功数据传出去
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(successfulTransactionWithResponseObject:)]) {
                [weakSelf.delegate successfulTransactionWithResponseObject:weakSelf.responseObject];
            }
            
            [weakSelf dismiss];
        });
        
    }
    
    if ([self.view.subviews.lastObject isKindOfClass:[MCSelectPaymentCardView class]]) {
        _selectPaymentCardView.msg = msg;
    }else {
        _addPaymentCardView.msg = msg;
    }
}

@end
