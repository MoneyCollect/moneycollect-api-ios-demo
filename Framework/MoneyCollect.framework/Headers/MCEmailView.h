//
//  MCEmailView.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/13.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCBillingDetails;

NS_ASSUME_NONNULL_BEGIN

@interface MCEmailView : UIView

/** 输入框内容是否校验成功,用户可以使用 KVO 实时监听这个值的改变,来控制支付按钮是否可以点击 */
@property (nonatomic,assign) BOOL isCheck;

/** 输入框收集的数据 */
@property (nonatomic,strong) MCBillingDetails *billingDetails;

@end

NS_ASSUME_NONNULL_END
