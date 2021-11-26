//
//  MCThreeDSWebViewController.h
//  MoneyCollect
//
//  Created by 邓侃 on 2021/10/29.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCThreeDSWebViewController : UIViewController
/** 3D处理 完成的结果返回 */
@property (nonatomic, copy) void(^completeBlock)(NSString *msg, NSDictionary *responseObject);

- (void)loadURL:(NSString *)urlStr paymentID:(NSString *)paymentID clientSecret:(NSString *)clientSecret;

@end

NS_ASSUME_NONNULL_END
