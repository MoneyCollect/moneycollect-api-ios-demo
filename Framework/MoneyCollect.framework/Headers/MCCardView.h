//
//  MCCardView.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/12.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCard;

NS_ASSUME_NONNULL_BEGIN

@interface MCCardView : UIView

/** 输入框内容是否校验成功,用户可以使用 KVO 实时监听这个值的改变,来控制支付按钮是否可以点击 */
@property (nonatomic,assign) BOOL isCheck;

/** 收集的卡号数据 */
@property (nonatomic,strong) MCCard *card;

@end

NS_ASSUME_NONNULL_END
