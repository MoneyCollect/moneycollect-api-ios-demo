//
//  MCShipping.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/18.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCAddress;

NS_ASSUME_NONNULL_BEGIN

@interface MCShipping : NSObject
/** 地址 */
@property (nonatomic,strong) MCAddress *address;

/** 名 */
@property (nonatomic,copy) NSString *firstName;

/** 姓 */
@property (nonatomic,copy) NSString *lastName;

/** 电话 */
@property (nonatomic,copy) NSString *phone;

@end

NS_ASSUME_NONNULL_END
