//
//  MCAddCardViewController.m
//  MoneyCollect
//
//  Created by 邓侃 on 2021/9/28.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCAddCardViewController.h"
#import "MCPresentationController.h"
#import <MoneyCollect/MoneyCollect.h>


/** 导航栏的高度 */
#define NavigationViewHeight  AdaptedHeight(54)
/** cell 的高度 */
#define cellHeight   AdaptedHeight(60)
/** 表头的高度 */
#define headerHeight   AdaptedHeight(40)
/** 表尾的高度 */
#define footerHeight   AdaptedHeight(60)
/** 展示的最大高度 */
#define MAX_HEIGHT  SCREEN_HEIGHT - KTopStatusBarH
/** 添加卡View的高度 */
#define AddCardContentViewHeight AdaptedHeight(73 + 50 + 10 + 110 + 10 + 110 + 10 + 30 + 130)

@interface MCAddCardViewController ()<MCNavigationViewDelegate,UITableViewDelegate,UITableViewDataSource,MCAddPaymentCardViewDelegate>
/** 导航View */
@property (nonatomic,strong) MCNavigationView *navigationView;
/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 表头 */
@property (nonatomic,strong) UIView *headerView;
/** 表尾 */
@property (nonatomic,strong) MCFooterView *footerView;
/** 添加卡View */
@property (nonatomic,strong) MCAddPaymentCardView *addPaymentCardView;
/** 记录高度 */
@property (nonatomic,assign) CGFloat lastHeight;
/** 数据源 */
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation MCAddCardViewController

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
                // 高度
                CGFloat Height = self.dataSource.count * AdaptedHeight(60) + AdaptedHeight(40) + AdaptedHeight(60) + NavigationViewHeight + BottomSafeAreaHeight + 5;
                if (Height > MAX_HEIGHT) {  // 一屏显示不完,需要滚动
                    Height = MAX_HEIGHT;
                }
                
                // 设置内容的高度
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.view.y = SCREEN_HEIGHT - Height;
                    weakSelf.view.height = Height;
                }];
                
            }else { // 没有数据
                
                // 设置内容的高度
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.view.y = SCREEN_HEIGHT - (NavigationViewHeight + footerHeight + BottomSafeAreaHeight + 5);
                    weakSelf.view.height = NavigationViewHeight + footerHeight + BottomSafeAreaHeight + 5;
                }];
            }
            
        }else { // 请求失败
            
            // 设置内容的高度
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.view.y = SCREEN_HEIGHT - (NavigationViewHeight + footerHeight + BottomSafeAreaHeight + 5);
                weakSelf.view.height = NavigationViewHeight + footerHeight + BottomSafeAreaHeight + 5;
            }];
            
            NSLog(@"获取卡列表失败,code = %ld 错误信息 = %@",(long)error.code,error.localizedDescription);
        }
        
        [weakSelf.view addSubview:weakSelf.navigationView];
        if (weakSelf.dataSource.count) { // 有数据
            [weakSelf.view addSubview:weakSelf.tableView];
        }else {
            [weakSelf.view addSubview:weakSelf.footerView];
        }
    }];
    
}

#pragma mark - 懒加载UI
- (MCNavigationView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[MCNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationViewHeight)];
        _navigationView.delegate = self;
        _navigationView.titleStr = MCLocalizedString(@"安全付款");
        //设置投影
        [_navigationView setShadowPathWith:[UIColor jk_colorWithHex:0x7E7E7E] shadowOpacity:0.6 shadowRadius:2 shadowSide:ABShadowPathBottom shadowPathWidth:2];
    }
    return _navigationView;
}

#pragma mark - TableView
- (UITableView *)tableView
{
    if (!_tableView) {
        // 高度
        CGFloat Height = self.dataSource.count * AdaptedHeight(60) + AdaptedHeight(40) + AdaptedHeight(60);
        if ((Height + NavigationViewHeight + BottomSafeAreaHeight + 5) > MAX_HEIGHT) {  // 一屏显示不完,需要滚动
            Height = MAX_HEIGHT - NavigationViewHeight - BottomSafeAreaHeight - 5;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationView.bottom + 5, SCREEN_WIDTH, Height) style:UITableViewStylePlain];
        _tableView.rowHeight = cellHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = Height == (MAX_HEIGHT - NavigationViewHeight - BottomSafeAreaHeight - 5) ? YES : NO;
        
        //添加表头
        _tableView.tableHeaderView = self.headerView;
        
        //添加表尾
        _tableView.tableFooterView = self.footerView;
        
        
        //注册cell
        [_tableView registerClass:[MCShowCardCell class] forCellReuseIdentifier:NSStringFromClass([MCShowCardCell class])];

    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        //添加标题
        CGFloat cardNumberLBW = SCREEN_WIDTH - AdaptedWidth(20 + 10 + 35 + 20);
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(AdaptedWidth(20), 0, cardNumberLBW, headerHeight)];
        titleLB.backgroundColor = [UIColor whiteColor];
        titleLB.text = @"select payment card";
        titleLB.textColor = [UIColor jk_colorWithHex:0x666666];
        titleLB.font = Font_Regular(17.0f);
    
        [_headerView addSubview:titleLB];
        
        // 添加向下箭头
        // 向下箭头
        CGFloat arrowW = AdaptedWidth(10);
        CGFloat arrowH = AdaptedHeight(6);
        UIImageView *downArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - arrowW - AdaptedWidth(34), (headerHeight - arrowH) * 0.5, arrowW, arrowH)];
        downArrow.image = MCImgName(@"DownArrow");
        [_headerView addSubview:downArrow];
        
    }
    return _headerView;
}

- (MCFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[MCFooterView alloc] initWithFrame:CGRectMake(0, _navigationView.bottom + AdaptedHeight(5), SCREEN_WIDTH, footerHeight)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        // 添加点击手势
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addSaveCard:)];
        [_footerView addGestureRecognizer:addTap];
        
    }
    return _footerView;
}

- (MCAddPaymentCardView *)addPaymentCardView
{
    if (!_addPaymentCardView) {
        _addPaymentCardView = [[MCAddPaymentCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AddCardContentViewHeight)];
        _addPaymentCardView.titleStr = MCLocalizedString(@"Add a card");
        _addPaymentCardView.type = AddCard;
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataSource.count) {
        return self.dataSource.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCShowCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MCShowCardCell class]) forIndexPath:indexPath];
    
    // 取数据
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    NSDictionary *cardDic = [dic objectForKey:@"card"];
    
    [cell reloadDataWithBrand:[cardDic objectForKey:@"brand"] last4:[cardDic objectForKey:@"last4"]];
    
    cell.isSelected = indexPath.row == 0 ? true : false;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 把数据传出去
    NSDictionary *paymentMethodParams = [_dataSource objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(addCardViewSelectedCardPaymentMethod:)]) {
        [_delegate addCardViewSelectedCardPaymentMethod:paymentMethodParams];
        
        [self dismiss];
    }
}

#pragma mark - MCNavigationViewDelegate & 返回
- (void)back
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 添加保存卡
- (void)addSaveCard:(UITapGestureRecognizer *)tap
{
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

#pragma mark - 添加卡
- (void)addPayNowClick:(MCPaymentMethodParams *)paymentMethodParams atIsSelected:(BOOL)isSelected
{
    if (_delegate && [_delegate respondsToSelector:@selector(addCardViewAddCardPaymentMethod:atIsSelected:)]) {
        [_delegate addCardViewAddCardPaymentMethod:paymentMethodParams atIsSelected:isSelected];
    }
    
    [self dismiss];
}

#pragma mark - AddPaymentCardView返回
- (void)AddPaymentCardViewBack
{
    // 移除 添加卡 view
    [self.addPaymentCardView removeFromSuperview];
    self.addPaymentCardView = nil;
    
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
