//
//  MCNavigationView.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/9/29.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCNavigationViewDelegate <NSObject>
/** 返回 */
- (void)back;

@end;

NS_ASSUME_NONNULL_BEGIN

@interface MCNavigationView : UIView

/** 标题 */
@property (nonatomic,copy) NSString *titleStr;

@property(nonatomic,weak) id<MCNavigationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
