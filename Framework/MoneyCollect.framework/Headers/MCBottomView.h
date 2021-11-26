//
//  MCBottomView.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/27.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

///** 类型 */
typedef NS_ENUM(NSUInteger,MCAddCardType){
    /** 添加卡支付 */
    MCAddCardPayment = 0,
    /** 添加卡 */
    MCAddCard = 1,
};

@protocol MCBottomViewDelegate <NSObject>
/** 按钮的点击事件 */
- (void)bottomButtonClick;

@end;

NS_ASSUME_NONNULL_BEGIN

@interface MCBottomView : UIView
/** 按钮是否能点击 */
@property (nonatomic,assign) BOOL isClick;

/** 提示信息 */
@property (nonatomic,copy) NSString *msg;

@property(nonatomic,weak) id<MCBottomViewDelegate> delegate;

/** 是 支付 还是 添加卡 */
@property (nonatomic,assign) MCAddCardType type;

/** 支付成功后是否恢复原样 */
@property (nonatomic,assign) BOOL isRestart;

/** 错误信息文字的高度 */
@property (nonatomic,assign) CGFloat textH;

@end

NS_ASSUME_NONNULL_END
