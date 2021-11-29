# Accept a payment

Mobile Sdk发起交易示例图

![3张-1@2x](https://user-images.githubusercontent.com/92731686/141933450-8daa8efa-1648-4410-b0bf-97d6735d9da5.png)

### Set up MoneyConnectServer-sideClient-side

First, you need a MoneyConnect account. [Register now](https://portal.moneycollect.com/registerr).

**<h1>1. Set up Server-side</h1>**
客户端想要访问大部分MoneyConnectServer API，需要商户后台通过私钥发起请求，下载github上模拟商户后台服务接口代码[Download now](https://github.com/MoneyCollect/moneycollect-api-android-demo/tree/mcappserver).


> **<h3> 1.1 替换MobilePayController.java文件里面的公钥私钥成自己的<h3>**
```
//Your account PUBLIC_SECRET("Bearer "+PUBLIC_SECRET)
private static final String PUBLIC_SECRET = "Bearer live_pu_OGJ0EidwEg4GjymEiRD7cUBk7IQIYmhwhJlUM****";
//Your account PRIVATE_SECRET("Bearer "+PRVATE_SECRET)
private static final String PRIVATE_SECRET = "Bearer live_pr_OGJ0EidwEg4GjymEiRD4MRxBCo0OumdH6URv****";
```
代码中公钥和私钥格式是（"Bearer "+PUBLIC_SECRET）

> **<h3> 1.2 修改端口号（默认写死9898）<h3>**
```
server.port=9898
```
商户把代码中的公钥和私钥替换成自己的然后开启服务代码默认端口9099可修改 （商户后台接口地址为本机ip:9898）

**<h1>2. Set up Client-side</h1>**

导入MoneyCollect iOS sdk，然后初始化sdk
> **<h3> 2.1 Installation <h3>**
To integrate MoneyCollect into your Xcode project using CocoaPods, specify it in your Podfile:
 ```
 pod 'MoneyCollect', '~> 0.0.1'

```
> **<h3> 2.2 初始化sdk<h3>**

在项目 AppDelegate 里面初始化 MoneyCollect iOS sdk

```
/** API公钥 */
@property (nonatomic,copy) NSString *publishableKey;
/** 商户传的 IP 地址 */
@property (nonatomic,copy) NSString *customerIPAddress;

/// 设置公钥 和 商户IP地址
/// @param publishableKey 公钥
/// @param customerIPAddress IP地址
- (void)setPublishableKey:(NSString * _Nonnull)publishableKey atCustomerIPAddress:(NSString *)customerIPAddress;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 初始化 公钥 和 服务器地址
    [[MCAPIClient shared] setPublishableKey:@"Bearer test_pu_1sWrsjQP9PJiCwGsYv3risSn8YBCIEMNoVFIo8eR6s" atCustomerIPAddress:@"http://192.168.2.100:9898/api"];
    
    return YES;
    
}

```

**<h1>3. 构建发起交易数据参数,然后开启支付</h1>**
商户构建好交易请求参数，点击Checkout按钮开启支付（constructMCCreatePaymentParams 方法构造数据详情请参考 Example）

```
#pragma mark - 按钮点击事件
- (void)checkoutBtnClick:(UIButton *)sender
{
    // 初始化控制器
    MCSelectPaymentCardVC *selectPaymentCardVC = [[MCSelectPaymentCardVC alloc] init];
    selectPaymentCardVC.delegate = self;

    // 构建请求参数
    selectPaymentCardVC.customerID = [MCConfigurationFile getCustomerID];
    selectPaymentCardVC.billingDetails = [MCConfigurationFile getBillingDetailsModel];
    selectPaymentCardVC.createPaymentParams = [self constructMCCreatePaymentParams];
    
    // 加载视图
    [selectPaymentCardVC present:self];
}

```


当客户完点击Pay Now完成付款后，将关闭支付页面返回到 Example 下的 MCPaymentSheetCheckoutVC，并将支付结果responseObject 通过代理返回
```
#pragma mark - MCSelectPaymentCardVCDelegate
- (void)successfulTransactionWithResponseObject:(NSDictionary *)responseObject
{
    // 交易状态
    NSString *status = [[responseObject objectForKey:@"data"] objectForKey:@"status"];
    
    if ([status isEqualToString:@"succeeded"]) {
        
        NSLog(@"success");
        
    }else if ([status isEqualToString:@"failed"]) {
        
        NSLog(@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"errorMessage"]);
        
    }else if ([status isEqualToString:@"pending"]) {
        
        NSLog(@"pending");
        
    }else if ([status isEqualToString:@"uncaptured"]) {
        
        NSLog(@"uncaptured");
        
    }else if ([status isEqualToString:@"canceled"]) {
        
        NSLog(@"canceled");
        
    }else {
        
        NSLog(@"pending");
        
    }
}

```


**<h1>4. Additional testing resources</h1>**
There are several test cards you can use to make sure your integration is ready for production. Use them with any CVC, postal code, and future expiration date.

|  Card Number| Brand  |DESCRIPTION          |
| :------------- | :------------- | :-------------- |
| 4242 4242 4242 4242    | Visa            | Succeeds and immediately processes the payment. |
| 3566 0020 2036 0505    | JCBA            | Succeeds and immediately processes the payment. |
| 6011 1111 1111 1117    | Discover        | Succeeds and immediately processes the payment. |
| 3782 8224 6310 0052    | American Express| Succeeds and immediately processes the payment. |
| 5555 5555 5555 4444    | Mastercard      | Succeeds and immediately processes the payment. |
| 4000 0025 0000 3155    | Visa            | 3D Secure 2 authentication . |
| 4000 0000 0000 0077    | Visa            | Always fails with a decline code of `declined`. |********
