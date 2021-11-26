//
//  MCConfirmPaymentParams.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/19.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCShipping;

NS_ASSUME_NONNULL_BEGIN

@interface MCConfirmPaymentParams : NSObject
/** 金额 */
@property (nonatomic,copy) NSString *amount;

/** 币种 */
@property (nonatomic,copy) NSString *currency;

/** 商户接收通知的地址 */
@property (nonatomic,copy) NSString *notifyUrl;

/** PaymentMethodID */
@property (nonatomic,copy) NSString *paymentMethod;

/** paymentID, createPayment 接口会返回 */
@property (nonatomic,copy) NSString *paymentID;

/** 接收收据的Email */
@property (nonatomic,copy) NSString *receiptEmail;

/** 返回地址 */
@property (nonatomic,copy) NSString *returnUrl;

/** 是否用于未来支付（on/off）; on 时候自动将支付方式附加到指定的客户；off时候不做处理；默认off */
@property (nonatomic,copy) NSString *setupFutureUsage;

/** <#description#> */
@property (nonatomic,strong) MCShipping *shipping;

/** 来源网址 */
@property (nonatomic,copy) NSString *website;

/** createPayment 接口会返回 */
@property (nonatomic,copy) NSString *clientSecret;

@end

NS_ASSUME_NONNULL_END
