//
//  UIView+ABShadowPath.h
//  AsiaBillPaySDK
//
//  Created by 邓侃 on 2021/8/13.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ABShadowPathSide) {
    /** 左 */
    ABShadowPathLeft,
    /** 右 */
    ABShadowPathRight,
    /** 上 */
    ABShadowPathTop,
    /** 下 */
    ABShadowPathBottom,
    /** 左 右 下 */
    ABShadowPathNoTop,
    /** 所有 */
    ABShadowPathAllSide
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ABShadowPath)

/// 添加投影
/// @param shadowColor 阴影颜色
/// @param shadowOpacity 阴影透明度，默认0
/// @param shadowRadius 阴影半径，默认3
/// @param shadowPathSide 设置哪一侧的阴影
/// @param shadowPathWidth 阴影的宽度
- (void)setShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(ABShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

@end

NS_ASSUME_NONNULL_END
