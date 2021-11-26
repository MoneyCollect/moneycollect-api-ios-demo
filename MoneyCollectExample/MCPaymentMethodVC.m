//
//  MCPaymentMethodVC.m
//  Example
//
//  Created by 邓侃 on 2021/11/11.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCPaymentMethodVC.h"
#import "MCConfigurationFile.h"
#import <MoneyCollect/MoneyCollect.h>

@interface MCPaymentMethodVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic,strong) NSArray *dataSource;
/** log打印信息 */
@property (nonatomic,strong) UITextView *logTextView;
/** 卡信息收集 */
@property (nonatomic,strong) MCCardView *cardView;
/** 卡号ID */
@property (nonatomic,copy) NSString *paymentMethodID;

@end

@implementation MCPaymentMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"PaymentMethod";
    
    [self.view addSubview:self.cardView];
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

#pragma mark - 加载数据
- (void)loadData
{
    _dataSource = @[@"Get Customers PaymentMethod Test",@"Create PaymentMethod Test",@"Attach PaymentMethod Test",@"Retrieve PaymentMethod Test"];
}

#pragma mark - UI懒加载
- (MCCardView *)cardView
{
    if (!_cardView) {
        _cardView = [[MCCardView alloc] initWithFrame:CGRectMake(AdaptedWidth(15), AdaptedHeight(70), SCREEN_WIDTH - AdaptedWidth(30), AdaptedHeight(110))];
    }
    return _cardView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _cardView.bottom + AdaptedHeight(20), SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - BottomSafeAreaHeight - _cardView.bottom - AdaptedHeight(20)) style:UITableViewStylePlain];
        _tableView.rowHeight = AdaptedHeight(60);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //去除cell分割线
        _tableView.separatorStyle = NO;
        //添加tableView尾
        // 创建一个textView,用来显示打印信息
        UITextView *logTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - BottomSafeAreaHeight - 4 * AdaptedHeight(60))];
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
    // 收起键盘
    [self.view endEditing:YES];
    
    switch (indexPath.row) {
        case 0:
            [self getCustomersPaymentMethodTest];
        break;
        case 1:
            [self createPaymentMethodTest];
            break;
        case 2:
            [self attachPaymentMethodTest];
            break;
        case 3:
            [self retrievePaymentMethodTest];
            break;
        default:
            break;
    }
}

#pragma mark - Get Customers PaymentMethod Test
- (void)getCustomersPaymentMethodTest
{
    NSString *customerID = [MCConfigurationFile getCustomerID];
    
    __weak typeof(self) weakSelf = self;
    // 提示框
    [ZSProgressHUD showHUDShowText:@""];
    // 获取卡列表
    [[MCAPIClient shared] getCustomersPaymentMethodsAtCustomerId:customerID completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Get Customers PaymentMethod....\n%@",responseObject];

            
        }else { // 请求失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Get Customers PaymentMethod Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
    }];
}

#pragma mark - Create PaymentMethod Test
- (void)createPaymentMethodTest
{
    // 1.创建支付方式
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    
    MCPaymentMethodParams *paymentMethodParams = [[MCPaymentMethodParams alloc] init];
    paymentMethodParams.billingDetails = billingDetails;
    paymentMethodParams.card = _cardView.card;
    
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    [[MCAPIClient shared] createPaymentMethodWithParams:paymentMethodParams completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
          
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Create PaymentMethod....\n%@",responseObject];
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) { // 创建支付方式成功
                
                weakSelf.paymentMethodID = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                
                // 保存 paymentMethodID
                [MCConfigurationFile savePaymentMethodID:weakSelf.paymentMethodID];
                
            }
            
        }else { // 失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Create PaymentMethod Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
    }];
}

#pragma mark - Attach PaymentMethod Test
- (void)attachPaymentMethodTest
{
    NSString *customerID = [MCConfigurationFile getCustomerID];
    
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    [[MCAPIClient shared] attachPaymentMethodToCustomer:customerID paymentMethod:_paymentMethodID completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Attach PaymentMethod....\n%@",responseObject];
            
        }else { // 失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Attach PaymentMethod Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
        
    }];
}

#pragma mark - Retrieve PaymentMethod Test
- (void)retrievePaymentMethodTest
{
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    
    [[MCAPIClient shared] retrievePaymentMethod:_paymentMethodID completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Retrieve PaymentMethod....\n%@",responseObject];
            
        }else { // 失败
            
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Retrieve PaymentMethod Failed....\n%ld\n%@",(long)error.code,error.localizedDescription];
            
        }
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
