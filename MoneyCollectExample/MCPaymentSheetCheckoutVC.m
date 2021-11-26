//
//  MCPaymentSheetCheckoutVC.m
//  Example
//
//  Created by 邓侃 on 2021/11/3.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCPaymentSheetCheckoutVC.h"
#import "MCProductCell.h"
#import <MoneyCollect/MoneyCollect.h>
#import "MCConfigurationFile.h"
#import "MCProductDetailsModel.h"
#import "MCSelectPaymentCardVC.h"

@interface MCPaymentSheetCheckoutVC ()<UITableViewDelegate,UITableViewDataSource,MCSelectPaymentCardVCDelegate>
/** You cart */
@property (nonatomic,strong) UILabel *headLabel;
/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataSource;
/** 底部总价格View */
@property (nonatomic,strong) UIView *bottomView;
/** 商品总价 */
@property (nonatomic,strong) UILabel *totalPriceLB;

@end

@implementation MCPaymentSheetCheckoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"PaymentSheet Demo";
    
    [self createUI];
}

#pragma mark - 创建UI
- (void)createUI
{
    [self.view addSubview:self.headLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - 加载数据
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSArray *iconArray = @[@"产品1",@"产品2",@"产品3",@"产品4"];
        NSArray *titleArray = @[@"Waterproof SmartWatch A5",@"GPS SmartWatch T3",@"GPS SmartWatch T2",@"Waterproof SmartWatch A6"];
        NSArray *priceArray = @[@"109.00",@"69.00",@"59.00",@"385.00"];
        
        for (int i = 0; i < titleArray.count; i++) {
            MCProductDetailsModel *model = [[MCProductDetailsModel alloc] init];
            model.icon = [iconArray objectAtIndex:i];
            model.name = [titleArray objectAtIndex:i];
            model.price = [priceArray objectAtIndex:i];
            model.isSelected = YES;
            
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

#pragma mark - 懒加载UI
- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(AdaptedWidth(15), 0, SCREEN_WIDTH - AdaptedWidth(30), AdaptedHeight(60))];
        _headLabel.text = @"Your cart";
        _headLabel.textColor = [UIColor blackColor];
        _headLabel.font = Font_Bold(17.0f);
    }
    return _headLabel;
}

#pragma mark - UI懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headLabel.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - AdaptedHeight(60) - AdaptedHeight(210) - BottomSafeAreaHeight) style:UITableViewStylePlain];
        _tableView.rowHeight = AdaptedHeight(80);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //去除cell分割线
        _tableView.separatorStyle = NO;
        //添加tableView尾
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        
        //注册cell
        [_tableView registerClass:[MCProductCell class] forCellReuseIdentifier:NSStringFromClass([MCProductCell class])];

    }
    return _tableView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        CGFloat H = AdaptedHeight(210);
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - H - kNavBarHeight - BottomSafeAreaHeight, SCREEN_WIDTH, H)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        // 添加一条灰线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(AdaptedWidth(15), 0, SCREEN_WIDTH - AdaptedWidth(30), 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_bottomView addSubview:line];
        
        // total
        UILabel *totalLB = [[UILabel alloc] initWithFrame:CGRectMake(AdaptedWidth(15), 0, AdaptedWidth(100), AdaptedHeight(60))];
        totalLB.text = @"total";
        totalLB.font = Font_Bold(17.0f);
        totalLB.textColor = [UIColor blackColor];
        [_bottomView addSubview:totalLB];
        
        // 总价格
        UILabel *totalPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - AdaptedWidth(15) - totalLB.width, totalLB.top, totalLB.width, totalLB.height)];
        // 计算总价
        NSInteger totalPrice = 0;
        for (MCProductDetailsModel *moder in self.dataSource) {
            totalPrice += [moder.price integerValue];
        }
        
        NSString *currency = [MCConfigurationFile getCurrency]; // 货币单位
        if ([currency isEqualToString:@"USD"]) { // 美元 ,最小单位美分
            totalPriceLB.text = [NSString stringWithFormat:@"$%.2f",totalPrice * 1.0];
        }else if ([currency isEqualToString:@"KRW"]) {
            totalPriceLB.text = [NSString stringWithFormat:@"₩%ld",totalPrice];
        }else if ([currency isEqualToString:@"IQD"]) {
            totalPriceLB.text = [NSString stringWithFormat:@"ID%.3f",totalPrice * 1.0];
        }else {
            totalPriceLB.text = [NSString stringWithFormat:@"JPY￥%ld",totalPrice];
        }
        
        totalPriceLB.font = Font_Bold(17.0f);
        totalPriceLB.textColor = [UIColor blackColor];
        totalPriceLB.textAlignment = NSTextAlignmentRight;
        [_bottomView addSubview:totalPriceLB];
        _totalPriceLB = totalPriceLB;
        
        // checkout
        UIButton *checkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkoutBtn.frame = CGRectMake(AdaptedWidth(20), totalPriceLB.bottom + AdaptedHeight(10), SCREEN_WIDTH - AdaptedWidth(40), totalLB.height);
        [checkoutBtn setTitle:@"Checkout" forState:UIControlStateNormal];
        [checkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkoutBtn.backgroundColor = [UIColor blackColor];
        [checkoutBtn addTarget:self action:@selector(checkoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //切圆角
        checkoutBtn.layer.cornerRadius = AdaptedWidth(8);
        checkoutBtn.layer.masksToBounds = YES;
        [_bottomView addSubview:checkoutBtn];
        
        // cancel
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(checkoutBtn.left, checkoutBtn.bottom + AdaptedHeight(10), checkoutBtn.width, checkoutBtn.height);
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor systemBlueColor];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //切圆角
        cancelBtn.layer.cornerRadius = AdaptedWidth(8);
        cancelBtn.layer.masksToBounds = YES;
        [_bottomView addSubview:cancelBtn];
        
    }
    return _bottomView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MCProductCell class]) forIndexPath:indexPath];
    cell.model = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCProductDetailsModel *model = [_dataSource objectAtIndex:indexPath.row];
    model.isSelected = !model.isSelected; // 选中取反
    [_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
    
    // 计算总价
    NSInteger totalPrice = 0;
    for (int i = 0; i < _dataSource.count; i++) {
        MCProductDetailsModel *productDetailsModel = [_dataSource objectAtIndex:i];
        if (productDetailsModel.isSelected) { // 商品选中才去计算
            totalPrice += [productDetailsModel.price integerValue];
        }
    }
    
    NSString *currency = [MCConfigurationFile getCurrency]; // 货币单位
    if ([currency isEqualToString:@"USD"]) { // 美元 ,最小单位美分
        _totalPriceLB.text = [NSString stringWithFormat:@"$%.2f",totalPrice * 1.0];
    }else if ([currency isEqualToString:@"KRW"]) {
        _totalPriceLB.text = [NSString stringWithFormat:@"₩%ld",totalPrice];
    }else if ([currency isEqualToString:@"IQD"]) {
        _totalPriceLB.text = [NSString stringWithFormat:@"ID%.3f",totalPrice * 1.0];
    }else {
        _totalPriceLB.text = [NSString stringWithFormat:@"JPY￥%ld",totalPrice];
    }
    
    //刷表格
    [_tableView reloadData];
}

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

#pragma mark - 取消按钮点击事件
- (void)cancelBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark - 构建 MCCreatePaymentParams 对象
- (MCCreatePaymentParams *)constructMCCreatePaymentParams
{
    // 币种
    NSString *currency = [MCConfigurationFile getCurrency];
    // 计算总价
    NSInteger totalPrice = 0;
    for (MCProductDetailsModel *moder in self.dataSource) {
        if (moder.isSelected) { // 商品选中,价格累加
            totalPrice += [moder.price integerValue];
        }
    }
    
    // 1.调用创建支付（扣款）接口
    MCCreatePaymentParams *params = [[MCCreatePaymentParams alloc] init];
    
    // 货币最小单位系数
    NSInteger transnum = 0;
    
    if ([currency isEqualToString:@"USD"]) { // 美元 ,最小单位美分  transnum : 100
        transnum = 100;
    }else if ([currency isEqualToString:@"KRW"]) { // 韩元 transnum : 1
        transnum = 1;
    }else if ([currency isEqualToString:@"IQD"]) { // 伊拉克第纳尔 transnum : 1000
        transnum = 1000;
    }else { // 日元 transnum : 1
        transnum = 1;
    }
    
    params.amount = [NSString stringWithFormat:@"%ld",totalPrice * transnum];
    params.currency = currency;
    params.confirmationMethod = @"manual";
    params.descriptionStr = @"test";
    
    NSMutableArray *lineItems = [NSMutableArray array];
    for (MCProductDetailsModel *productDetailsModel in _dataSource) {
        if (productDetailsModel.isSelected) { // 选中 结算 的商品
            
            MCLineItem *lineItem = [[MCLineItem alloc] init];
            lineItem.amount = [NSString stringWithFormat:@"%ld",productDetailsModel.price.integerValue * transnum];
            lineItem.currency = currency;
            lineItem.descriptionStr = [NSString stringWithFormat:@"%@ commodity test description",productDetailsModel.name];
            lineItem.images = @[@"http://localhost/item.jpg"];
            lineItem.name = productDetailsModel.name;
            lineItem.quantity = 1;
            
            [lineItems addObject:lineItem];
        }
    }
    params.lineItems = lineItems;
    
    params.notifyUrl = @"http://localhost:8080/notify";
    params.orderNo = [MCConfigurationFile getTimestamp];
    params.preAuth = @"n";
    params.receiptEmail = @"112374@gmail.com";
    params.returnUrl = @"http://localhost:8080/return";
    params.website = @"https://baidu.com";
    params.statementDescriptor = @"Descriptor";
    

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
    
    return params;
}

@end
