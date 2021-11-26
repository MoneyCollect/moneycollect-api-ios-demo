//
//  MCAddPaymentCardView.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/22.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCPaymentMethodParams;

///** 类型 */
typedef NS_ENUM(NSUInteger,AddCardType){
    /** 添加卡支付 */
    AddCardPayment = 0,
    /** 添加卡 */
    AddCard = 1,
};

@protocol MCAddPaymentCardViewDelegate <NSObject>
/** 返回 */
- (void)AddPaymentCardViewBack;
/** 添加支付 */
- (void)addPayNowClick:(MCPaymentMethodParams *_Nullable)paymentMethodParams atIsSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MCAddPaymentCardView : UIView
/** 标题 */
@property (nonatomic,copy) NSString *titleStr;

/** 错误信息提示 */
@property (nonatomic,copy) NSString *msg;

@property(nonatomic,weak) id<MCAddPaymentCardViewDelegate> delegate;

/** ScrollView */
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) AddCardType type;

@end

NS_ASSUME_NONNULL_END
