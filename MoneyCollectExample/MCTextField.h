//
//  MCTextField.h
//  Example
//
//  Created by 邓侃 on 2021/11/10.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCTextField : UIView
/** 占位符文字 */
@property (nonatomic,copy) NSString *placeholderStr;
/** 文本 */
@property (nonatomic,copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
