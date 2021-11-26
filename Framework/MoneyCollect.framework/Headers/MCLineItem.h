//
//  MCLineItem.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/19.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCLineItem : NSObject
/** 商品金额 */
@property (nonatomic,copy) NSString *amount;

/** 商品币种 */
@property (nonatomic,copy) NSString *currency;

/** 描述 */
@property (nonatomic,copy) NSString *descriptionStr;

/** 商品图片列表 */
@property (nonatomic,strong) NSArray <NSString *> *images;

/** 商品名称 */
@property (nonatomic,copy) NSString *name;

/** 商品数量 */
@property (nonatomic,assign) NSInteger quantity;


@end

NS_ASSUME_NONNULL_END
