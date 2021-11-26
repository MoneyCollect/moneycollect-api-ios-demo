//
//  MCSelectPaymentCardView.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/22.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCSelectPaymentCardViewDelegate <NSObject>
/** 返回 */
- (void)back;
/** 支付 */
- (void)payNowClick:(NSDictionary *_Nullable)paymentMethodParams;
/** 添加卡 */
- (void)addSaveCard:(UITapGestureRecognizer *_Nullable)tap;

@end;


NS_ASSUME_NONNULL_BEGIN

@interface MCSelectPaymentCardView : UIView

/** 数据源 */
@property (nonatomic,strong) NSArray *dataSource;

@property(nonatomic,weak) id<MCSelectPaymentCardViewDelegate> delegate;

/** 错误信息提示 */
@property (nonatomic,copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
