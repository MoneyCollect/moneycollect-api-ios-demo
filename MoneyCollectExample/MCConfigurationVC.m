//
//  MCConfigurationVC.m
//  Example
//
//  Created by 邓侃 on 2021/11/10.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCConfigurationVC.h"
#import "MCTextField.h"
#import <MoneyCollect/MoneyCollect.h>
#import "MCConfigurationFile.h"

@interface MCConfigurationVC ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) MCEmailView *emailView;
@property (nonatomic,strong) MCTextField *phone;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UISegmentedControl *sgCtrl;
@end

@implementation MCConfigurationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Configuration File";
    
    [self createUI];
    
    // 添加点击屏幕手势,消除键盘
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewCancelKeyBoard:)];
    [self.view addGestureRecognizer:tapView];
}

#pragma mark - 创建UI
- (void)createUI
{
    [self.view addSubview:self.scrollView];
    [self createTextField];
    [_scrollView addSubview:self.emailView];
    [_scrollView addSubview:self.phone];
    [_scrollView addSubview:self.sgCtrl];
    [_scrollView addSubview:self.saveButton];
}

#pragma mark - 懒加载UI
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight - BottomSafeAreaHeight)];
        CGFloat scrollViewContentH = SCREEN_HEIGHT - kNavBarHeight - BottomSafeAreaHeight;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollViewContentH);
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)createTextField
{
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    MCAddress *address = billingDetails.address;
    NSArray *textArray = @[address.line1,address.line2,address.city,address.state,address.postalCode,address.country];
    CGFloat W = (SCREEN_WIDTH - AdaptedWidth(30 + 20)) * 0.5;
    NSArray * placeholderStrArr = @[@"Address line1",@"Address line2",@"City",@"State",@"PostCode",@"Country"];
    
    for (int i = 0; i < placeholderStrArr.count; i++) {
        
        MCTextField *textfield = [[MCTextField alloc] initWithFrame:CGRectMake(AdaptedWidth(15) + (W + AdaptedWidth(20)) * (i % 2), AdaptedHeight(20) + AdaptedHeight(60) * (i / 2), W, AdaptedHeight(50))];
        textfield.placeholderStr = [placeholderStrArr objectAtIndex:i];
        textfield.text = [textArray objectAtIndex:i];
        
        [_scrollView addSubview:textfield];

    }
}

- (MCEmailView *)emailView
{
    if (!_emailView) {
        CGFloat Y = _scrollView.subviews.lastObject.bottom;
        _emailView = [[MCEmailView alloc] initWithFrame:CGRectMake(AdaptedWidth(15), Y + AdaptedHeight(40), SCREEN_WIDTH - AdaptedWidth(30), AdaptedHeight(110))];
    }
    return _emailView;
}

- (MCTextField *)phone
{
    if (!_phone) {
        MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
        _phone = [[MCTextField alloc] initWithFrame:CGRectMake(AdaptedWidth(15), _emailView.bottom + AdaptedHeight(10), SCREEN_WIDTH - AdaptedWidth(30), AdaptedHeight(50))];
        _phone.placeholderStr = @"Phone";
        _phone.text = billingDetails.phone;
    }
    return _phone;
}

- (UISegmentedControl *)sgCtrl
{
    if (!_sgCtrl) {
        _sgCtrl = [[UISegmentedControl alloc] initWithItems:@[@"USD", @"KRW",@"IQD",@"JPY"]];
        _sgCtrl.frame = CGRectMake(AdaptedWidth(15), _phone.bottom + AdaptedHeight(20), AdaptedWidth(200), AdaptedHeight(30));
        _sgCtrl.backgroundColor = [UIColor blackColor];
        if (@available(iOS 13.0, *)) {
            _sgCtrl.selectedSegmentTintColor = [UIColor systemBlueColor];
        } else {
            // Fallback on earlier versions
            _sgCtrl.tintColor = [UIColor systemBlueColor];
        }

        [_sgCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        
        NSString *currency = [MCConfigurationFile getCurrency];
        
        // 默认选中第几个
        if ([currency isEqualToString:@"USD"]) {
            _sgCtrl.selectedSegmentIndex = 0;
        }else if ([currency isEqualToString:@"KRW"]) {
            _sgCtrl.selectedSegmentIndex = 1;
        }else if ([currency isEqualToString:@"IQD"]) {
            _sgCtrl.selectedSegmentIndex = 2;
        }else {
            _sgCtrl.selectedSegmentIndex = 3;
        }
        
    }
    return _sgCtrl;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        CGFloat W = AdaptedWidth(200);
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake((SCREEN_WIDTH - W) * 0.5, _sgCtrl.bottom + AdaptedHeight(40), W, AdaptedHeight(44));
        _saveButton.backgroundColor = [UIColor blackColor];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = Font_Bold(15.0f);
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        //切圆角
        _saveButton.layer.cornerRadius = AdaptedWidth(8);
        _saveButton.layer.masksToBounds = YES;
    
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}


#pragma mark - 保存数据,更新数据
- (void)saveButtonClick:(UIButton *)sender
{
    // 存储数据
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    MCAddress *address = billingDetails.address;
    
    // 地址1
    MCTextField *line1 = _scrollView.subviews.firstObject;
    address.line1 = line1.text;
    
    // 地址2
    MCTextField *line2 = [_scrollView.subviews objectAtIndex:1];
    address.line2 = line2.text;
    
    // city
    MCTextField *city = [_scrollView.subviews objectAtIndex:2];
    address.city = city.text;
    
    // state
    MCTextField *state = [_scrollView.subviews objectAtIndex:3];
    address.state = state.text;
    
    // postCode
    MCTextField *postCode = [_scrollView.subviews objectAtIndex:4];
    address.postalCode = postCode.text;
    
    // country
    MCTextField *country = [_scrollView.subviews objectAtIndex:5];
    address.country = country.text;
    
    billingDetails.address = address;
    
    // phone
    billingDetails.phone = _phone.text;
    
    // email
    if (_emailView.billingDetails.email.length) {
        billingDetails.email = _emailView.billingDetails.email;
    }
    
    // firstname
    if (_emailView.billingDetails.firstName.length) {
        billingDetails.firstName = _emailView.billingDetails.firstName;
    }
    
    // lastName
    if (_emailView.billingDetails.lastName.length) {
        billingDetails.lastName = _emailView.billingDetails.lastName;
    }
    
    [MCConfigurationFile saveBillingDetailsModel:billingDetails];
    
    NSString *currency = @"";
    switch (_sgCtrl.selectedSegmentIndex) {
        case 0:
            currency = @"USD";
            break;
        case 1:
            currency = @"KRW";
            break;
        case 2:
            currency = @"IQD";
            break;
        case 3:
            currency = @"JPY";
            break;
        default:
            break;
    }
    
    [MCConfigurationFile saveCurrency:currency];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)touchViewCancelKeyBoard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

@end
