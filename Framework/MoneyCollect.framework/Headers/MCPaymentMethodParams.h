//
//  MCPaymentMethodParams.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/19.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCBillingDetails, MCCard;

NS_ASSUME_NONNULL_BEGIN

@interface MCPaymentMethodParams : NSObject

@property (nonatomic,strong) MCBillingDetails *billingDetails;

/** 卡信息 */
@property (nonatomic,strong) MCCard *card;

@end

NS_ASSUME_NONNULL_END
