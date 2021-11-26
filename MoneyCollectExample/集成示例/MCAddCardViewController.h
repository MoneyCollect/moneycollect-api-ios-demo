//
//  MCAddCardViewController.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/9/28.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCPaymentMethodParams, MCBillingDetails;

@protocol MCAddCardViewControllerDelegate <NSObject>
/** 选中哪张卡用来支付 */
- (void)addCardViewSelectedCardPaymentMethod:(NSDictionary *_Nullable)paymentMethodParams;
/** 添加卡 */
- (void)addCardViewAddCardPaymentMethod:(MCPaymentMethodParams *_Nullable)paymentMethodParams atIsSelected:(BOOL)isSelected;
@end;


NS_ASSUME_NONNULL_BEGIN

@interface MCAddCardViewController : UIViewController
/** 商户ID */
@property (nonatomic,copy) NSString *customerID;
/** 结算明细 */
@property (nonatomic,strong) MCBillingDetails *billingDetails;

@property(nonatomic,weak) id<MCAddCardViewControllerDelegate> delegate;


/// 弹出视图
/// @param viewController 以哪个视图作为背景
- (void)present:(UIViewController *)viewController;


/// 关闭视图
- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
