//
//  NSBundle+ABBundle.h
//  AsiaBillPaySDK
//
//  Created by 邓侃 on 2021/9/9.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ABBundle)

+ (instancetype)ab_Bundle;

+ (NSString *)localizedStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
