//
//  MCProductCell.h
//  Example
//
//  Created by 邓侃 on 2021/11/3.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCProductDetailsModel;

NS_ASSUME_NONNULL_BEGIN

@interface MCProductCell : UITableViewCell

@property (nonatomic,strong) MCProductDetailsModel *model;

@end

NS_ASSUME_NONNULL_END
