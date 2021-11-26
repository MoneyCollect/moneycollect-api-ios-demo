//
//  MCAddress.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/9.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCAddress : NSObject
/** 城市 */
@property (nonatomic,copy) NSString *city;

/** 国家 */
@property (nonatomic,copy) NSString *country;

/** 用户街道地址的第一行（例如“123 Fake St”） */
@property (nonatomic,copy) NSString *line1;

/** 用户街道地址的公寓、楼层号等（例如“公寓1A”） */
@property (nonatomic,copy) NSString *line2;

/** 邮编 */
@property (nonatomic,copy) NSString *postalCode;

/** 州 */
@property (nonatomic,copy) NSString *state;

@end

NS_ASSUME_NONNULL_END
