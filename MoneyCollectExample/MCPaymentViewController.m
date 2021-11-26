//
//  MCPaymentViewController.m
//  Example
//
//  Created by 邓侃 on 2021/11/12.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCPaymentViewController.h"
#import "MCConfigurationFile.h"
#import <MoneyCollect/MoneyCollect.h>

@interface MCPaymentViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic,strong) NSArray *dataSource;
/** log打印信息 */
@property (nonatomic,strong) UITextView *logTextView;
/** 创建支付返回的数据 */
@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,copy) NSString *paymentID;

@property (nonatomic,copy) NSString *clientSecret;

@end

@implementation MCPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Payment";
    
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

#pragma mark - 加载数据
- (void)loadData
{
    _dataSource = @[@"Create Payment Test",@"Confirm Payment Test",@"Retrieve Payment Test"];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - BottomSafeAreaHeight) style:UITableViewStylePlain];
        _tableView.rowHeight = AdaptedHeight(60);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //去除cell分割线
        _tableView.separatorStyle = NO;
        //添加tableView尾
        // 创建一个textView,用来显示打印信息
        UITextView *logTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - BottomSafeAreaHeight - 3 * AdaptedHeight(60))];
        logTextView.textColor = [UIColor blackColor];
        logTextView.backgroundColor = [UIColor lightGrayColor];
        logTextView.font = Font_Bold(15.0f);
        logTextView.editable = NO;
        [self.view addSubview:logTextView];
        _logTextView = logTextView;
        _tableView.tableFooterView = logTextView;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    }
    return _tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self createPaymentTest];
        break;
        case 1:
            [self confirmPaymentTest];
            break;
        case 2:
            [self retrievePaymentTest];
            break;

        default:
            break;
    }
}

#pragma mark - Create Payment Test
- (void)createPaymentTest
{
    // 币种
    NSString *currency = [MCConfigurationFile getCurrency];
    // CustomerID
    NSString *customerID = [MCConfigurationFile getCustomerID];
    // paymentMethodID
    NSString *paymentMethodID = [MCConfigurationFile getPaymentMethodID];
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    
    MCCreatePaymentParams *params = [[MCCreatePaymentParams alloc] init];
    params.amount = @"10000";
    params.currency = currency;
    params.confirmationMethod = @"manual";
    params.customerId = customerID;
    params.descriptionStr = @"test";
    
    MCLineItem *lineItem = [[MCLineItem alloc] init];
    lineItem.amount = @"10000";
    lineItem.currency = currency;
    lineItem.descriptionStr = @"1111";
    lineItem.images = @[@"http://localhost/item.jpg"];
    lineItem.name = @"测试";
    lineItem.quantity = 1;
    
    NSMutableArray *lineItems = [NSMutableArray array];
    [lineItems addObject:lineItem];
    params.lineItems = lineItems;
    
    params.notifyUrl = @"http://localhost:8080/notify";
    params.orderNo = [MCConfigurationFile getTimestamp];
    params.paymentMethod = paymentMethodID;
    params.preAuth = @"n";
    params.receiptEmail = @"112374@gmail.com";
    params.returnUrl = @"http://localhost:8080/return";
    params.setupFutureUsage = @"on";
    
    MCShipping *shipping = [[MCShipping alloc] init];
    shipping.address = billingDetails.address;
    shipping.firstName = billingDetails.firstName;
    shipping.lastName = billingDetails.lastName;
    shipping.phone = billingDetails.phone;
    
    params.shipping = shipping;
    params.website = @"https://baidu.com";
    params.statementDescriptor = @"Descriptor";
    
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    [[MCAPIClient shared] createPaymentWithParams:params completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Create Payment....\n%@",responseObject];
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) { // 创建支付方式成功（提交交易订单）
                
                NSDictionary *data = [responseObject objectForKey:@"data"];
                weakSelf.data = data;
                
            }
            
        }else { // 失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Create Payment Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
        
    }];
}

#pragma mark - Confirm Payment Test
- (void)confirmPaymentTest
{
    if (!_data) {
        [ZSProgressHUD showDpromptText:@"Please create a payment order first"];
        return;
    }
    
    NSString *paymentMethod = [MCConfigurationFile getPaymentMethodID];;
    if (!paymentMethod) {
        [ZSProgressHUD showDpromptText:@"The payment method is empty"];
        return;
    }
    
    MCConfirmPaymentParams *params = [[MCConfirmPaymentParams alloc] init];
    params.amount = [_data objectForKey:@"amount"];
    params.currency = [_data objectForKey:@"currency"];
    params.paymentID = [_data objectForKey:@"id"];
    params.notifyUrl = [_data objectForKey:@"notifyUrl"];
    params.paymentMethod = [_data objectForKey:@"paymentMethod"];
    params.receiptEmail = [_data objectForKey:@"receiptEmail"];
    params.returnUrl = [_data objectForKey:@"returnUrl"];
    params.setupFutureUsage = [_data objectForKey:@"setupFutureUsage"];
    params.clientSecret = [_data objectForKey:@"clientSecret"];
    
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    
    MCShipping *shipping = [[MCShipping alloc] init];
    shipping.address = billingDetails.address;
    shipping.firstName = billingDetails.firstName;
    shipping.lastName = billingDetails.lastName;
    shipping.phone = billingDetails.phone;
    
    params.shipping = shipping;
    params.website = @"https://baidu.com";
    
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    [[MCAPIClient shared] confirmPaymentWithParams:params completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Confirm Payment....\n%@",responseObject];
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) {
                
                weakSelf.paymentID = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                weakSelf.clientSecret = [[responseObject objectForKey:@"data"] objectForKey:@"clientSecret"];
                
            }
            
        }else { // 失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Confirm Payment Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
        
    }];
}

#pragma mark - Retrieve Payment Test
- (void)retrievePaymentTest
{
    if (!(_paymentID && _clientSecret)) {
        [ZSProgressHUD showDpromptText:@"paymentID or clientSecret is empty"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    [[MCAPIClient shared] retrievePayment:_paymentID clientSecret:_clientSecret completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Retrieve Payment....\n%@",responseObject];
            
        }else { // 失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Retrieve Payment Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
    }];
}

@end
