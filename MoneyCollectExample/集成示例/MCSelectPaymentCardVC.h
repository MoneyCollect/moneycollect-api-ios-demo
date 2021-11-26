//
//  MCSelectPaymentCardVC.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/11.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCPaymentMethodParams, MCBillingDetails, MCCreatePaymentParams;

@protocol MCSelectPaymentCardVCDelegate <NSObject>
/** 交易成功代理方法 */
- (void)successfulTransactionWithResponseObject:(NSDictionary *_Nullable)responseObject;

@end;


NS_ASSUME_NONNULL_BEGIN

@interface MCSelectPaymentCardVC : UIViewController
/** 商户ID */
@property (nonatomic,copy) NSString *customerID;
/** 结算明细 */
@property (nonatomic,strong) MCBillingDetails *billingDetails;
/** 创建支付参数对象 */
@property (nonatomic,strong) MCCreatePaymentParams *createPaymentParams;

@property(nonatomic,weak) id<MCSelectPaymentCardVCDelegate> delegate;


/// 弹出视图
/// @param viewController 以哪个视图作为背景
- (void)present:(UIViewController *)viewController;


/// 关闭视图
- (void)dismiss;


/// 接口请求完成调用此方法消除加载动画
/// @param msg 后台返回的提示信息
- (void)requestCompleted:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
