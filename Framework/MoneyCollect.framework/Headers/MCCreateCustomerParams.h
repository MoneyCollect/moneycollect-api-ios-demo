//
//  MCCreateCustomerParams.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/19.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCAddress, MCShipping;

NS_ASSUME_NONNULL_BEGIN

@interface MCCreateCustomerParams : NSObject

/** 地址 */
@property (nonatomic,strong) MCAddress *address;

/** 描述 */
@property (nonatomic,copy) NSString *descriptionStr;

/** 邮箱 */
@property (nonatomic,copy) NSString *email;

/** 名 */
@property (nonatomic,copy) NSString *firstName;

/** 姓 */
@property (nonatomic,copy) NSString *lastName;

/** 电话 */
@property (nonatomic,copy) NSString *phone;

/** <#description#> */
@property (nonatomic,strong) MCShipping *shipping;

@end

NS_ASSUME_NONNULL_END
