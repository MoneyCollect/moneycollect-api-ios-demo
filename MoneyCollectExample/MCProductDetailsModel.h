//
//  MCProductDetailsModel.h
//  Example
//
//  Created by 邓侃 on 2021/11/15.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCProductDetailsModel : NSObject
/** 商品名称 */
@property (nonatomic,copy) NSString *name;
/** 商品图片 */
@property (nonatomic,copy) NSString *icon;
/** 商品价格 */
@property (nonatomic,copy) NSString *price;
/** 商品是否被选中 */
@property (nonatomic,assign) BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
