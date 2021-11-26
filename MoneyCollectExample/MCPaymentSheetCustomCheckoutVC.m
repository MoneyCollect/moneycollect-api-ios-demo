//
//  MCPaymentSheetCustomCheckoutVC.m
//  Example
//
//  Created by 邓侃 on 2021/11/3.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCPaymentSheetCustomCheckoutVC.h"
#import "MCProductCell.h"
#import <MoneyCollect/MoneyCollect.h>
#import "MCConfigurationFile.h"
#import "MCProductDetailsModel.h"
#import "MCAddCardViewController.h"
#import "MCThreeDSWebViewController.h"

@interface MCPaymentSheetCustomCheckoutVC ()<UITableViewDelegate,UITableViewDataSource,MCBottomViewDelegate,MCAddCardViewControllerDelegate>
/** You cart */
@property (nonatomic,strong) UILabel *headLabel;
/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataSource;
/** 底部总价格View */
@property (nonatomic,strong) UIView *bottomView;
/** selectBtn */
@property (nonatomic,strong) UIButton *selectBtn;
/** 底部支付按钮 */
@property (nonatomic,strong) MCBottomView *bottomPayNow;
/** 控件收集的参数 */
@property (nonatomic,strong) NSDictionary *paymentMethodParams;
/** 商品总价 */
@property (nonatomic,strong) UILabel *totalPriceLB;

@end

@implementation MCPaymentSheetCustomCheckoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"PaymentSheet Custom Demo";
    
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
        CGFloat H = AdaptedHeight(60 + 40 + 130);
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - H - kNavBarHeight - BottomSafeAreaHeight, SCREEN_WIDTH, H)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        // 添加一条灰线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(AdaptedWidth(15), 0, SCREEN_WIDTH - AdaptedWidth(30), 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_bottomView addSubview:line];
        
        // total
        UILabel *totalLB = [[UILabel alloc] initWithFrame:CGRectMake(AdaptedWidth(15), 0, AdaptedWidth(150), AdaptedHeight(60))];
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
        
        // Payment Method
        UILabel *paymentMethodLB = [[UILabel alloc] initWithFrame:CGRectMake(totalLB.left, totalLB.bottom, totalLB.width, AdaptedHeight(40))];
        paymentMethodLB.textColor = [UIColor blackColor];
        paymentMethodLB.text = @"Payment Method";
        paymentMethodLB.font = Font_Bold(17.0f);
        [_bottomView addSubview:paymentMethodLB];

        // Select
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(totalPriceLB.left, totalPriceLB.bottom, totalPriceLB.width, paymentMethodLB.height);
        [selectBtn setTitle:@"Select" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        selectBtn.backgroundColor = [UIColor whiteColor];
        selectBtn.titleLabel.font = Font_Bold(17.0f);
        
        // 文字靠右显示
        selectBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [selectBtn addTarget:self action:@selector(selectCardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn = selectBtn;
        
        [_bottomView addSubview:selectBtn];
        
        // 底部支付按钮
        MCBottomView *bottomPayNow = [[MCBottomView alloc] initWithFrame:CGRectMake(0, paymentMethodLB.bottom, SCREEN_WIDTH, AdaptedHeight(130))];
        bottomPayNow.delegate = self;
        bottomPayNow.backgroundColor = [UIColor whiteColor];
        bottomPayNow.isClick = NO;
        // 是否支付完成按钮恢复原样
        bottomPayNow.isRestart = YES;
        _bottomPayNow = bottomPayNow;
        [_bottomView addSubview:bottomPayNow];
        
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
- (void)selectCardButtonClick:(UIButton *)sender
{
    // 初始化对象
    MCAddCardViewController *addCardVC = [[MCAddCardViewController alloc] init];
    addCardVC.delegate = self;
    
    // 构建参数
    addCardVC.customerID = [MCConfigurationFile getCustomerID];
    
    // 显示视图
    [addCardVC present:self];
    
}


#pragma mark - MCAddCardViewControllerDelegate
// 选中某张卡
- (void)addCardViewSelectedCardPaymentMethod:(NSDictionary *)paymentMethodParams
{
    NSString *brand = [[paymentMethodParams objectForKey:@"card"] objectForKey:@"brand"];
    NSString *last4 = [[paymentMethodParams objectForKey:@"card"] objectForKey:@"last4"];
    
    // 加载 bundle
    NSBundle *resoursBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MoneyCollectResours" ofType:@"bundle"]];
    UIImage *image = [UIImage imageNamed:brand inBundle:resoursBundle compatibleWithTraitCollection:nil];
    
    [_selectBtn setImage:image forState:UIControlStateNormal];
    [_selectBtn setTitle:[NSString stringWithFormat:@"%@ ···· %@",@"",last4] forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 调整一下button图片的大小
    [_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 0)];
    _selectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    // 按钮可以点击
    _bottomPayNow.isClick = YES;
    _paymentMethodParams = paymentMethodParams;
    
}

// 添加某张卡
- (void)addCardViewAddCardPaymentMethod:(MCPaymentMethodParams *)paymentMethodParams atIsSelected:(BOOL)isSelected
{
    // 1.创建支付方式
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    paymentMethodParams.billingDetails.address = billingDetails.address;
    paymentMethodParams.billingDetails.phone = billingDetails.phone;
    
    // 开启提示框
    [ZSProgressHUD showHUDShowText:@""];
    __weak typeof(self) weakSelf = self;
    [[MCAPIClient shared] createPaymentMethodWithParams:paymentMethodParams completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
          
        // 消提示框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) { // 创建支付方式成功
                
                NSDictionary *data = [responseObject objectForKey:@"data"];
                NSString *brand = [[data objectForKey:@"card"] objectForKey:@"brand"];
                NSString *last4 = [[data objectForKey:@"card"] objectForKey:@"last4"];
                NSString *ID = [data objectForKey:@"id"];
                
                [weakSelf.selectBtn setImage:[UIImage imageNamed:brand] forState:UIControlStateNormal];
                [weakSelf.selectBtn setTitle:[NSString stringWithFormat:@"%@ ···· %@",@"",last4] forState:UIControlStateNormal];
                [weakSelf.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                // 按钮可以点击
                weakSelf.bottomPayNow.isClick = YES;
                weakSelf.paymentMethodParams = data;
                
                if (isSelected) { // 保存卡
                    [[MCAPIClient shared] attachPaymentMethodToCustomer:[MCConfigurationFile getCustomerID] paymentMethod:ID completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                                            
                        if (!error) { // 请求成功
                            
                            NSLog(@"保存卡(添加卡,添加支付方式):%@",responseObject);
                            
                        }else {
                            NSLog(@"保存卡失败,code = %ld 错误信息 = %@",error.code,error.localizedDescription);
                        }
                                            
                    }];
                }
                
            }
            
        }else { // 失败
            NSLog(@"创建支付方式失败,code = %ld 错误信息 = %@",error.code,error.localizedDescription);
        }
    }];
}


#pragma mark - 支付
- (void)bottomButtonClick
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.bottomView.y += weakSelf.bottomPayNow.textH;
        weakSelf.bottomView.height -= weakSelf.bottomPayNow.textH;
    }];
    
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
    params.customerId = [MCConfigurationFile getCustomerID];
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
    params.paymentMethod = [_paymentMethodParams objectForKey:@"id"];
    params.preAuth = @"n";
    params.receiptEmail = @"112374@gmail.com";
    params.returnUrl = @"http://localhost:8080/return";
    params.setupFutureUsage = @"off";
    
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
          
        if (!error) { // 请求成功
            
            NSString *code = [responseObject objectForKey:@"code"];
            
            if ([code isEqualToString:@"success"]) { // 创建支付成功（提交交易订单）
                
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
                
                params.shipping = shipping;
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
                            
                            threeDSVC.completeBlock = ^(NSString *msg, NSDictionary *responseObject){
                                
                                // 消除动画
                                [weakSelf requestCompletedMsg:msg];
                                
                            };
                            
                            [weakSelf presentViewController:threeDSVC animated:YES completion:nil];
                            
                        }else { // 普通交易
                            
                            // 交易状态
                            NSString *status = [[responseObject objectForKey:@"data"] objectForKey:@"status"];
                            // 提示语
                            NSString *msg = @"";
                            
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
                            
                            // 消除动画
                            [weakSelf requestCompletedMsg:msg];
                        }
                    
                        NSLog(@"确认扣款:%@",responseObject);
                        
                    }else { // 请求失败
                        
                        // 消除动画
                        [weakSelf requestCompletedMsg:error.localizedDescription];
                        
                        NSLog(@"确认支付（确认扣款）失败,code = %ld 错误信息 = %@",error.code,error.localizedDescription);
                    }
                                
                }];
                
            }else { // 创建支付方式失败
                
                // 消除动画
                [weakSelf requestCompletedMsg:[responseObject objectForKey:@"msg"]];
            }
            
        }else { // 请求失败
            
            // 消除动画
            [weakSelf requestCompletedMsg:error.localizedDescription];
            
            NSLog(@"创建支付（提交交易订单）失败,code = %ld 错误信息 = %@",error.code,error.localizedDescription);
        }
        
    }];
}


#pragma mark - 结束
- (void)requestCompletedMsg:(NSString *)msg
{
    _bottomPayNow.msg = msg;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.bottomView.y -= weakSelf.bottomPayNow.textH;
        weakSelf.bottomView.height += weakSelf.bottomPayNow.textH;
    }];
}


@end
