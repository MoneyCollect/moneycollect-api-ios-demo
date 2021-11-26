//
//  MCCreateCustomerVC.m
//  Example
//
//  Created by 邓侃 on 2021/11/11.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCCreateCustomerVC.h"
#import <MoneyCollect/MoneyCollect.h>
#import "MCConfigurationFile.h"

@interface MCCreateCustomerVC ()
/** log打印信息 */
@property (nonatomic,strong) UITextView *logTextView;
@end

@implementation MCCreateCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Create Customer";
    
    // 创建一个按钮
    CGFloat W = AdaptedWidth(200);
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake((SCREEN_WIDTH - W) * 0.5, AdaptedHeight(20), W, AdaptedHeight(44));
    createBtn.backgroundColor = [UIColor blackColor];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = Font_Bold(15.0f);
    [createBtn setTitle:@"create" forState:UIControlStateNormal];
    //切圆角
    createBtn.layer.cornerRadius = AdaptedWidth(8);
    createBtn.layer.masksToBounds = YES;

    [createBtn addTarget:self action:@selector(createButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    // 加个标题
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(AdaptedWidth(15), createBtn.bottom + AdaptedHeight(20), SCREEN_WIDTH - AdaptedWidth(30), AdaptedHeight(30))];
    titleLB.backgroundColor = [UIColor whiteColor];
    titleLB.textColor = [UIColor blackColor];
    titleLB.text = @"Log Information 👇🏻";
    titleLB.font = Font_Bold(15.0f);
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    
    // 创建一个textView,用来显示打印信息
    UITextView *logTextView = [[UITextView alloc] initWithFrame:CGRectMake(AdaptedWidth(15), titleLB.bottom, SCREEN_WIDTH - AdaptedWidth(30), SCREEN_HEIGHT - kNavBarHeight - titleLB.bottom - BottomSafeAreaHeight - AdaptedHeight(10))];
    logTextView.textColor = [UIColor blackColor];
    logTextView.backgroundColor = [UIColor lightGrayColor];
    logTextView.font = Font_Bold(15.0f);
    logTextView.editable = NO;
    [self.view addSubview:logTextView];
    _logTextView = logTextView;
   
}


- (void)createButtonClick:(UIButton *)sender
{
    MCBillingDetails *billingDetails = [MCConfigurationFile getBillingDetailsModel];
    
    MCShipping *shipping = [[MCShipping alloc] init];
    shipping.address = billingDetails.address;
    shipping.firstName = billingDetails.firstName;
    shipping.lastName = billingDetails.lastName;
    shipping.phone = billingDetails.phone;
    
    MCCreateCustomerParams *createCustomerParams = [[MCCreateCustomerParams alloc] init];
    createCustomerParams.address = billingDetails.address;
    createCustomerParams.shipping = shipping;
    createCustomerParams.descriptionStr = @"test";
    createCustomerParams.email = billingDetails.email;
    createCustomerParams.firstName = shipping.firstName;
    createCustomerParams.lastName = shipping.lastName;
    createCustomerParams.phone = shipping.phone;
    
    __weak typeof(self) weakSelf = self;
    [ZSProgressHUD showHUDShowText:@""];
    [[MCAPIClient shared] createCustomerWithParams:createCustomerParams completionBlock:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        
        // 消框
        [ZSProgressHUD hideAllHUDAnimated:YES];
        
        if (!error) { // 请求成功
    
            weakSelf.logTextView.text = [NSString stringWithFormat:@"Create Customer....\n%@",responseObject];
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) {
                 // 成功 , 保存 Customer ID
                NSString *customerID = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
                [MCConfigurationFile saveCustomerID:customerID];
                
            }
            
        }else {
            weakSelf.logTextView.text = error.localizedDescription;
        }
        
    }];
}
@end
