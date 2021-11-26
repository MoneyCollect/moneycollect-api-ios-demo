//
//  MCConfigurationFile.h
//  Example
//
//  Created by 邓侃 on 2021/11/9.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MoneyCollect/MoneyCollect.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCConfigurationFile : NSObject

+ (MCBillingDetails *)getBillingDetailsModel;

+ (void)saveBillingDetailsModel:(MCBillingDetails *)billingDetails;

+ (NSString *)getCurrency;

+ (void)saveCurrency:(NSString *)currency;

+ (NSString *)getCustomerID;

+ (void)saveCustomerID:(NSString *)customerID;

+ (NSString *)getPaymentMethodID;

+ (void)savePaymentMethodID:(NSString *)paymentMethodID;

+ (NSString *)getTimestamp;

@end

NS_ASSUME_NONNULL_END
