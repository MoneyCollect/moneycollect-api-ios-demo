//
//  UIView+Cutting.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/9/30.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Cutting)

/// 切圆角方法，必须在设置控件的bounds之后调用才有效果
/// @param corners 哪些角
/// @param radiusWidth 裁切宽度
- (void)cuttingViewbyRoundingCorners:(UIRectCorner)corners cornerRadiusWidth:(CGFloat)radiusWidth;

@end

NS_ASSUME_NONNULL_END
