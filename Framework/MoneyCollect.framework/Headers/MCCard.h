//
//  MCCard.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/19.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCCard : NSObject
/** 卡号 */
@property (nonatomic,copy) NSString *cardNo;

/** 月 */
@property (nonatomic,copy) NSString *expMonth;

/** 年 */
@property (nonatomic,copy) NSString *expYear;

/** 安全码 CVC */
@property (nonatomic,copy) NSString *securityCode;


@end

NS_ASSUME_NONNULL_END
