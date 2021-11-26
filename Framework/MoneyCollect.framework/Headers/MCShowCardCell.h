//
//  MCShowCardCell.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/11.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCShowCardCell : UITableViewCell

/** 是否选中 */
@property (nonatomic,assign) BOOL isSelected;

- (void)reloadDataWithBrand:(NSString *)brand last4:(NSString *)last4;

@end

NS_ASSUME_NONNULL_END
