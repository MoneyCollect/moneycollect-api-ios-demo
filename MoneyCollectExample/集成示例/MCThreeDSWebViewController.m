//
//  MCThreeDSWebViewController.m
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/29.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCThreeDSWebViewController.h"
#import <WebKit/WebKit.h>
#import <MoneyCollect/MoneyCollect.h>

@interface MCThreeDSWebViewController ()<WKNavigationDelegate,MCNavigationViewDelegate,UIAdaptivePresentationControllerDelegate>
/** webView */
@property (nonatomic,strong) WKWebView *webView;
/** 进度条 */
@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,copy) NSString *paymentID;

@property (nonatomic,copy) NSString *clientSecret;

@end

@implementation MCThreeDSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    // 打开手势 点击
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = YES;
    
    self.presentationController.delegate = self;
}

#pragma mark - 设置导航信息
- (void)setupNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TopStatusBar + NavigationBar ( 顶部状态栏 加 导航栏 )
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavBarHeight)];
//    navView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:navView];
    
    MCNavigationView *navigationBar = [[MCNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
}


#pragma mark - 懒加载UI
- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, AdaptedHeight(2))];
    }
    return _progressView;
}

#pragma mark - 加载数据
- (void)loadURL:(NSString *)urlStr paymentID:(NSString *)paymentID clientSecret:(NSString *)clientSecret
{
    //进度条
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *requestURL = [NSMutableURLRequest requestWithURL:url];
    //请求超时
    requestURL.timeoutInterval = 60;
    [self.webView loadRequest:requestURL];
    
    _paymentID = paymentID;
    _clientSecret = clientSecret;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //设置进度条
    self.progressView.progress = self.webView.estimatedProgress;
    //隐藏进度条
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
}


#pragma mark - WKNavigationDelegate (主要处理一些跳转、加载处理操作)
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    [self getStringFromH5QuitWithURLStr:urlStr];
    
    NSLog(@"---------------地址：%@",urlStr);
    
    decisionHandler(WKNavigationActionPolicyAllow);

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    
}


// 检索 url 是否包含 这三个字段
- (void)getStringFromH5QuitWithURLStr:(NSString *)urlStr
{
    if ([urlStr rangeOfString:@"payment_id"].location != NSNotFound && [urlStr rangeOfString:@"payment_client_secret"].location != NSNotFound && [urlStr rangeOfString:@"source_redirect_slug"].location != NSNotFound) {  // 包含
        
        [self retrievePayment];
        
    }else { // 不包含
        
    }
    
}

// 检索支付
- (void)retrievePayment
{
    __weak typeof(self) weakSelf = self;
    // 检索
    [[MCAPIClient shared] retrievePayment:_paymentID clientSecret:_clientSecret completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                
        // 提示语
        NSString *msg = @"";
        
        if (!error) {
            
            NSString *code = [responseObject objectForKey:@"code"];
            
            if ([code isEqualToString:@"success"]) {
                
                // 交易状态
                NSString *status = [[responseObject objectForKey:@"data"] objectForKey:@"status"];
                
                if ([status isEqualToString:@"succeeded"]) {
                    
                    msg = @"success";
                    
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
                
            }else {
                
                msg = [responseObject objectForKey:@"msg"];
            }
            
        }else {
            msg = error.localizedDescription;
        }
         
        // 传参
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock(msg, responseObject);
        }
        
        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    }];
}


//移除KVO
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


#pragma mark - 重写设置状态栏方法,设置状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent; //字体黑色（iOS出了暗黑模式,默认色是白色）
    } else {
        return UIStatusBarStyleDefault; // 默认色（其实就是黑色）
    }
}

#pragma mark - 返回
- (void)back
{
    __weak typeof(self) weakSelf = self;
    //添加一个提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:MCLocalizedString(@"您想取消付款吗？") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:MCLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:MCLocalizedString(@"确认") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        // 调用 retrievePayment 接口
        [weakSelf retrievePayment];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 监听下滑返回
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController
{
    if (_completeBlock) {
        _completeBlock(@"the payment is pending", [NSDictionary dictionary]);
    }
}

@end
