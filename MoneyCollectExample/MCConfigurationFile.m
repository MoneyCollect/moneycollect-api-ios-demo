//
//  MCConfigurationFile.m
//  Example
//
//  Created by 邓侃 on 2021/11/9.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCConfigurationFile.h"

@implementation MCConfigurationFile

+ (MCBillingDetails *)getBillingDetailsModel
{
    // 获取沙盒目录
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"MCBillingDetails.data"];
    MCBillingDetails *billingDetails = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (!billingDetails) { // 没有数据的话就 搞些默认的数据,并存起来
        
        MCAddress *address = [[MCAddress alloc] init];
        address.city = @"Blackrock";
        address.country = @"IE";
        address.line1 = @"123 Main Street";
        address.line2 = @"";
        address.postalCode = @"T37 F8HK";
        address.state = @"Co. Dublin";
        
        billingDetails = [[MCBillingDetails alloc] init];
        billingDetails.address = address;
        billingDetails.email = @"email@email.com";
        billingDetails.firstName = @"Jenny";
        billingDetails.lastName = @"Rosen";
        billingDetails.phone = @"+18008675309";
        
        [self saveBillingDetailsModel:billingDetails];
    }
    
    return billingDetails;
}

+ (void)saveBillingDetailsModel:(MCBillingDetails *)billingDetails
{
    // 获取沙盒目录
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"MCBillingDetails.data"];
    
    [NSKeyedArchiver archiveRootObject:billingDetails toFile:filePath];
}


+ (NSString *)getCurrency
{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"];
    
    if (!currency.length) {
        currency = @"USD";
    }
    
    return currency;
}

+ (void)saveCurrency:(NSString *)currency
{
    [[NSUserDefaults standardUserDefaults] setObject:currency forKey:@"Currency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerID
{
    NSString *customerID = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomerID"];
    if (!customerID.length) {
        customerID = @"cus_1458743587415257089";
    }
    return customerID;
}

+ (void)saveCustomerID:(NSString *)customerID
{
    [[NSUserDefaults standardUserDefaults] setObject:customerID forKey:@"CustomerID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getPaymentMethodID
{
    NSString *paymentMethodID = [[NSUserDefaults standardUserDefaults] objectForKey:@"PaymentMethodID"];
    
    return paymentMethodID;
}

+ (void)savePaymentMethodID:(NSString *)paymentMethodID
{
    [[NSUserDefaults standardUserDefaults] setObject:paymentMethodID forKey:@"PaymentMethodID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取当前的时间戳
+ (NSString *)getTimestamp
{
    NSDate *datenow = [NSDate date];
    NSTimeInterval interval = [datenow timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%.f",interval];
}

@end
