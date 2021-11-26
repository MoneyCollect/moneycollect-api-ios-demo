//
//  MCCreatePaymentParams.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/19.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCLineItem, MCShipping;

NS_ASSUME_NONNULL_BEGIN

@interface MCCreatePaymentParams : NSObject
/** 金额 */
@property (nonatomic,copy) NSString *amount;

/** 确认方式（automatic、manual），默认是automatic，如果是 automatic 则交易创建时候就会自动扣款；如果 manual 则需要调用 confirm 接口确认扣款 */
@property (nonatomic,copy) NSString *confirmationMethod;

/** 币种 */
@property (nonatomic,copy) NSString *currency;

/** 客户Id */
@property (nonatomic,copy) NSString *customerId;

/** 交易描述 */
@property (nonatomic,copy) NSString *descriptionStr;

/** 来源网址 */
@property (nonatomic,copy) NSString *website;

/** 商户接收通知的地址 */
@property (nonatomic,copy) NSString *notifyUrl;

/** 商户订单号 */
@property (nonatomic,copy) NSString *orderNo;

/** PaymentMethodID（如果 confirmationMethod = automatic）paymentMethod 不能为空 */
@property (nonatomic,copy) NSString *paymentMethod;

/** 是否预授权交易（y/n）, y 为预授权交易；n 普通交易；默认不传为 n */
@property (nonatomic,copy) NSString *preAuth;

/** 接收收据的Email */
@property (nonatomic,copy) NSString *receiptEmail;

/** 返回地址 */
@property (nonatomic,copy) NSString *returnUrl;

/** 是否用于未来支付（on/off）; on 时候自动将支付方式附加到指定的客户；off时候不做处理；默认off */
@property (nonatomic,copy) NSString *setupFutureUsage;

/** 商品列表 可以为空，最多只能有20个商品 */
@property (nonatomic,strong) NSArray <MCLineItem *> *lineItems;

/** <#description#> */
@property (nonatomic,strong) MCShipping *shipping;

@property (nonatomic,copy) NSString *statementDescriptor;

@end

NS_ASSUME_NONNULL_END
