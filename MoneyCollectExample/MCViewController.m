//
//  MCViewController.m
//  Example
//
//  Created by 邓侃 on 2021/9/27.
//

#import "MCViewController.h"
/** PaymentSheet Demo */
#import "MCPaymentSheetCheckoutVC.h"
/** PaymentSheet Custom Demo */
#import "MCPaymentSheetCustomCheckoutVC.h"
/** Customer */
#import "MCCreateCustomerVC.h"
/** PaymentMethod */
#import "MCPaymentMethodVC.h"
/** Payment */
#import "MCPaymentViewController.h"
/** 配置文件 */
#import "MCConfigurationVC.h"

#import <MoneyCollect/MoneyCollect.h>



@interface MCViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据 */
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation MCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Money Collect";
    
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

#pragma mark - 加载数据
- (void)loadData
{
    _dataSource = @[@"PaymentSheet Demo",@"PaymentSheet Custom Demo",@"Create Customer",@"PaymentMethod Example",@"Payment Example",@"Configuration"];
}

#pragma mark - UI懒加载
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
            [self paymentSheetDemo];
        break;
        case 1:
            [self paymentSheetCustomDemo];
            break;
        case 2:
            [self createCustomer];
            break;
        case 3:
            [self paymentMethodExample];
            break;
        case 4:
            [self paymentExample];
            break;
        case 5:
            [self ConfigurationExample];
        default:
            break;
    }
}

#pragma mark - PaymentSheet Demo
- (void)paymentSheetDemo
{
    MCPaymentSheetCheckoutVC *paymentSheetVC = [[MCPaymentSheetCheckoutVC alloc] init];
    [self.navigationController pushViewController:paymentSheetVC animated:YES];
}

#pragma mark - PaymentSheet Custom Demo
- (void)paymentSheetCustomDemo
{
    MCPaymentSheetCustomCheckoutVC *paymentSheetCustomVC = [[MCPaymentSheetCustomCheckoutVC alloc] init];
    [self.navigationController pushViewController:paymentSheetCustomVC animated:YES];
}

#pragma mark - Create Customer
- (void)createCustomer
{
    MCCreateCustomerVC *VC = [[MCCreateCustomerVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - PaymentMethod Example
- (void)paymentMethodExample
{
    MCPaymentMethodVC *VC = [[MCPaymentMethodVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Payment Example
- (void)paymentExample
{
    MCPaymentViewController *VC = [[MCPaymentViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Configuration Example
- (void)ConfigurationExample
{
    MCConfigurationVC *VC = [[MCConfigurationVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}








#pragma mark - 接口请求测试样例 可以作为参考 每条接口都有测试样例,下面这些代码没什么用,仅做参考
- (void)createCustomerTest
{
    MCAddress *address = [[MCAddress alloc] init];
    address.city = @"Blackrock";
    address.country = @"IE";
    address.line1 = @"123 Main Street";
    address.line2 = @"";
    address.postalCode = @"T37 F8HK";
    address.state = @"Co. Dublin";
    
    MCShipping *shipping = [[MCShipping alloc] init];
    shipping.address = address;
    shipping.firstName = @"Jenny";
    shipping.lastName = @"Rosen";
    shipping.phone = @"+18008675309";
    
    MCCreateCustomerParams *createCustomerParams = [[MCCreateCustomerParams alloc] init];
    createCustomerParams.address = address;
    createCustomerParams.shipping = shipping;
    createCustomerParams.descriptionStr = @"test";
    createCustomerParams.email = @"email@email.com";
    createCustomerParams.firstName = shipping.firstName;
    createCustomerParams.lastName = shipping.lastName;
    createCustomerParams.phone = shipping.phone;
    
    [[MCAPIClient shared] createCustomerWithParams:createCustomerParams completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        NSLog(@"createCustomer:%@",responseObject);
        
    }];
}

- (void)createPaymentMethodTest
{
    MCAddress *address = [[MCAddress alloc] init];
    address.city = @"Blackrock";
    address.country = @"IE";
    address.line1 = @"123 Main Street";
    address.line2 = @"";
    address.postalCode = @"T37 F8HK";
    address.state = @"Co. Dublin";
    
    MCBillingDetails *billingDetails = [[MCBillingDetails alloc] init];
    billingDetails.address = address;
    billingDetails.email = @"email@email.com";
    billingDetails.firstName = @"Jenny";
    billingDetails.lastName = @"Rosen";
    billingDetails.phone = @"+18008675309";
    
    MCCard *card = [[MCCard alloc] init];
    card.cardNo = @"4111111111111111";
    card.expMonth = @"12";
    card.expYear = @"2025";
    card.securityCode = @"123";
    
    MCPaymentMethodParams *params = [[MCPaymentMethodParams alloc] init];
    params.billingDetails = billingDetails;
    params.card = card;
    
    [[MCAPIClient shared] createPaymentMethodWithParams:params completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                
        NSLog(@"创建支付方式：%@",responseObject);
        
    }];
    
}

- (void)createPaymentTest
{
    MCCreatePaymentParams *params = [[MCCreatePaymentParams alloc] init];
    params.amount = @"10000";
    params.currency = @"USD";
    params.confirmationMethod = @"manual";
    params.customerId = @"cus_1450464892212617218";
    params.descriptionStr = @"test";
    
    MCLineItem *lineItem = [[MCLineItem alloc] init];
    lineItem.amount = @"10000";
    lineItem.currency = @"USD";
    lineItem.descriptionStr = @"1111";
    lineItem.images = @[@"http://localhost/item.jpg"];
    lineItem.name = @"测试";
    lineItem.quantity = 1;
    
    NSMutableArray *lineItems = [NSMutableArray array];
    [lineItems addObject:lineItem];
    params.lineItems = lineItems;
    
    params.notifyUrl = @"http://localhost:8080/notify";
    params.orderNo = @"JD11234";
    params.paymentMethod = @"pm_1450465533639139330";
    params.preAuth = @"n";
    params.receiptEmail = @"112374@gmail.com";
    params.returnUrl = @"http://localhost:8080/return";
    params.setupFutureUsage = @"on";
    
    MCAddress *address = [[MCAddress alloc] init];
    address.city = @"Blackrock";
    address.country = @"IE";
    address.line1 = @"123 Main Street";
    address.line2 = @"";
    address.postalCode = @"T37 F8HK";
    address.state = @"Co. Dublin";
    
    MCShipping *shipping = [[MCShipping alloc] init];
    shipping.address = address;
    shipping.firstName = @"Jenny";
    shipping.lastName = @"Rosen";
    shipping.phone = @"+18008675309";
    
    params.shipping = shipping;
    params.website = @"https://baidu.com";
    params.statementDescriptor = @"Descriptor";
    
    [[MCAPIClient shared] createPaymentWithParams:params completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        NSLog(@"创建支付：%@",responseObject);
        
    }];
}

- (void)confirmPaymentTest
{
    MCConfirmPaymentParams *params = [[MCConfirmPaymentParams alloc] init];
    params.amount = @"10000";
    params.currency = @"USD";
    params.paymentID = @"py_1450653541889875969";
    params.notifyUrl = @"http://localhost:8080/notify";
    params.paymentMethod = @"pm_1450465533639139330";
    params.receiptEmail = @"112374@gmail.com";
    params.returnUrl = @"http://localhost:8080/return";
    params.setupFutureUsage = @"on";
    
    MCAddress *address = [[MCAddress alloc] init];
    address.city = @"Blackrock";
    address.country = @"IE";
    address.line1 = @"123 Main Street";
    address.line2 = @"";
    address.postalCode = @"T37 F8HK";
    address.state = @"Co. Dublin";
    
    MCShipping *shipping = [[MCShipping alloc] init];
    shipping.address = address;
    shipping.firstName = @"Jenny";
    shipping.lastName = @"Rosen";
    shipping.phone = @"+18008675309";
    
    params.shipping = shipping;
    params.website = @"https://baidu.com";
    
    [[MCAPIClient shared] confirmPaymentWithParams:params completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        if (!error) {
            NSLog(@"确认支付：%@",responseObject);
        }else {
            NSLog(@"确认支付错误信息：%@",error.localizedDescription);
        }
    }];
    
}

- (void)retrievePaymentMethodTest
{
    [[MCAPIClient shared] retrievePaymentMethod:@"pm_1450465533639139330" completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
    
        NSLog(@"检索支付方式：%@",responseObject);
        
    }];
}

- (void)retrievePaymentTest
{
    [[MCAPIClient shared] retrievePayment:@"py_1450653541889875969" clientSecret:@"" completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            
        NSLog(@"检索支付：%@",responseObject);
        
    }];
}

@end
